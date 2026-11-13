import XCTest

@testable import TwitchIRC

final class TagValueDecodingTests: XCTestCase {
  func testEscapesAreDecodedOnce() {
    let cases = [
      (#"a\sb\:c\\d\re\nf"#, "a b;c\\d\re\nf"),
      (#"literal\\s"#, #"literal\s"#),
      (#"unknown\q"#, "unknownq"),
      ("trailing\\", "trailing"),
      ("👋🏽e\u{301}", "👋🏽e\u{301}"),
    ]
    for (wire, expected) in cases {
      var parser = ParametersParser("value=" + wire)
      XCTAssertEqual(parser.string(for: "value"), expected)
    }
  }

  func testTypedFieldsDecodeWhileRawTagsAndBodyRemainUntouched() throws {
    let line =
      #"@display-name=Some\sName;reply-parent-msg-body=hello\sworld;future=keep\sthis :viewer!viewer@viewer.tmi.twitch.tv PRIVMSG #example :literal\sbody"#
    let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
    guard case .privateMessage(let chat) = result.message else {
      return XCTFail("Expected a private message")
    }
    XCTAssertEqual(chat.displayName, "Some Name")
    XCTAssertEqual(chat.replyParent?.message, "hello world")
    XCTAssertEqual(chat.message, #"literal\sbody"#)
    XCTAssertEqual(result.text, line)
    XCTAssertEqual(result.rawMessage?.tags.first?.value, #"Some\sName"#)
    XCTAssertEqual(chat.parsingLeftovers.unusedPairs.first?.value, #"keep\sthis"#)
  }

  func testInvalidValuesRetainWireDiagnostics() {
    var parser = ParametersParser(#"number=\q;valid=\1"#)
    XCTAssertNil(parser.optionalUInt(for: "number"))
    XCTAssertEqual(parser.optionalUInt(for: "valid"), 1)
    XCTAssertEqual(parser.getLeftOvers().unparsedKeys.first?.value, #"\q"#)
  }

  func testExplicitConstructionDoesNotDecodeAgain() {
    let chat = PrivateMessage(
      channel: "example", message: "Hello", displayName: #"Some\sName"#,
      userLogin: "viewer", id: "id", roomID: "room", userID: "user")
    XCTAssertEqual(chat.displayName, #"Some\sName"#)
  }
}
