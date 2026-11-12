import XCTest

@testable import TwitchIRC

final class ClearMessageTests: XCTestCase {

  func testParsedValues1() throws {
    let string =
      "@login=ronni;target-msg-id=abc-123-def;room-id=;tmi-sent-ts=1642860513538 :tmi.twitch.tv CLEARMSG #dallas :HeyGuys"

    let clearMessage: ClearMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(clearMessage.channel, "dallas")
    XCTAssertEqual(clearMessage.message, "HeyGuys")
    XCTAssertEqual(clearMessage.userLogin, "ronni")
    XCTAssertEqual(clearMessage.targetMessageID, "abc-123-def")
    XCTAssertEqual(clearMessage.roomID, "")
    XCTAssertEqual(clearMessage.timestampMilliseconds, 1_642_860_513_538)
    XCTAssertTrue(
      clearMessage.parsingLeftovers.isEmpty,
      "Non-empty parsing left-overs: \(clearMessage.parsingLeftovers)")
  }
}
