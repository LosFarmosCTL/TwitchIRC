import XCTest

@testable import TwitchIRC

final class InlineMediaTests: XCTestCase {
  func testScalarRangesAndCharacterBoundaries() throws {
    let text = "👋🏽 Kappa"
    let range = try XCTUnwrap(MessageTextRange(unicodeScalarOffsets: 3..<8))
    XCTAssertEqual(range.text(in: text), "Kappa")
    XCTAssertEqual(String(text[try XCTUnwrap(range.stringRange(in: text))]), "Kappa")
    XCTAssertNil(range.text(in: "short"))
    XCTAssertNil(MessageTextRange(unicodeScalarOffsets: -1..<2))
    XCTAssertNil(MessageTextRange(unicodeScalarOffsets: 1..<1))
    let partial = try XCTUnwrap(MessageTextRange(unicodeScalarOffsets: 0..<1))
    XCTAssertEqual(partial.text(in: "e\u{301}"), "e")
    XCTAssertNil(partial.stringRange(in: "e\u{301}"))
  }

  func testMalformedMediaRetainsValidOccurrencesAndDiagnostics() {
    var parser = ParametersParser(
      "emotes=25:3-7,8-7,0-99,-1-2,0-9223372036854775807/broken;gifs=3-7|gif|https://example.com/a|b,invalid"
    )
    let emotes = parser.emotes(in: "👋🏽 Kappa")
    XCTAssertEqual(emotes.map(\.name), ["Kappa"])
    let gifs = parser.gifs(in: "👋🏽 Kappa")
    XCTAssertEqual(gifs.map(\.text), ["Kappa"])
    XCTAssertEqual(gifs.first?.url, "https://example.com/a|b")
    XCTAssertEqual(parser.getLeftOvers().unparsedKeys.count, 6)
  }

  func testActionTextAndMediaShareCoordinates() throws {
    let content = "\u{1}ACTION 👋🏽 Kappa\u{1}"
    let line =
      "@emotes=25:3-7;gifs=3-7|gif|https://example.com/gif :user!user@user.tmi.twitch.tv PRIVMSG #channel :"
      + content
    let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
    let chat: PrivateMessage = try TestUtils.parseAndUnwrap(string: line)
    XCTAssertTrue(chat.isAction)
    XCTAssertEqual(chat.message, "👋🏽 Kappa")
    XCTAssertEqual(chat.emotes.first?.name, "Kappa")
    XCTAssertEqual(chat.gifs.first?.text, "Kappa")
    XCTAssertEqual(result.rawMessage?.parameters.last, content)
    XCTAssertEqual(result.text, line)
  }

  func testIncompleteActionFramingIsPreserved() {
    for text in ["\u{1}ACTION hello", "ACTION hello", "\u{1}OTHER hello\u{1}"] {
      let parsed = MessageText(text)
      XCTAssertFalse(parsed.isAction)
      XCTAssertEqual(parsed.text, text)
    }
    XCTAssertEqual(MessageText("\u{1}ACTION \u{1}").text, "")
  }
}
