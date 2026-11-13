import XCTest

@testable import TwitchIRC

final class TagValueEncodingTests: XCTestCase {
  func testEscapesTagCharactersOnceAndPreservesUnicode() {
    let value = "a b;c\\d\re\nf 👋🏽e\u{301}"
    let encoded = IRCMessageTagValue.encode(value)
    XCTAssertEqual(encoded, #"a\sb\:c\\d\re\nf\s👋🏽é"#)
    XCTAssertEqual(IRCMessageTagValue.decode(encoded), value)
    XCTAssertEqual(IRCMessageTagValue.encode(#"\s"#), #"\\s"#)
  }

  func testOutgoingTagValuesRoundTripThroughAnEnvelope() throws {
    let nonce = "a b;c\\d\r\n"
    let replyID = "reply; with\\escapes"
    let serialized = OutgoingMessage.privateMessage(
      to: "example", message: "Hello; C:\\Games :)",
      messageIDToReply: replyID, clientNonce: nonce
    ).serialize()
    let envelope = try XCTUnwrap(RawIRCMessage(line: serialized))
    XCTAssertEqual(envelope.command, "PRIVMSG")
    XCTAssertEqual(envelope.parameters, ["#example", "Hello; C:\\Games :)"])
    XCTAssertEqual(envelope.tags.map(\.name), ["reply-parent-msg-id", "client-nonce"])
    XCTAssertEqual(
      envelope.tags.compactMap(\.value).map(IRCMessageTagValue.decode), [replyID, nonce])
  }

  func testMessageBodyIsEmittedAsSupplied() {
    let body = "literal\\s; :text\r\n\0"
    XCTAssertEqual(
      OutgoingMessage.privateMessage(to: "example", message: body).serialize(),
      "PRIVMSG #example :" + body)
  }
}
