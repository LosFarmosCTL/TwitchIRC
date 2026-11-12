import XCTest

@testable import TwitchIRC

final class ClearChatTests: XCTestCase {

  func testTaggedTimeoutPreservesIdentityAndTimestamp() throws {
    let clearChat: ClearChat = try TestUtils.parseAndUnwrap(
      string:
        "@room-id=324;target-user-id=42;tmi-sent-ts=1700000000000;ban-duration=60 :tmi.twitch.tv CLEARCHAT #dallas :ronni"
    )
    XCTAssertEqual(clearChat.banDuration, 60)
    XCTAssertEqual(clearChat.roomId, "324")
    XCTAssertEqual(clearChat.targetUserId, "42")
    XCTAssertEqual(clearChat.tmiSentTs, 1_700_000_000_000)
  }

  func testParsedValues1() throws {
    let string = ":tmi.twitch.tv CLEARCHAT #dallas"
    let clearChat: ClearChat = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(clearChat.channel, "dallas")
    XCTAssertEqual(clearChat.userLogin, nil)
    XCTAssertEqual(clearChat.banDuration, nil)
    XCTAssertEqual(clearChat.userIsPermanentlyBanned, false)
  }

  func testParsedValues2() throws {
    let string = ":tmi.twitch.tv CLEARCHAT #dallas :ronni"
    let clearChat: ClearChat = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(clearChat.channel, "dallas")
    XCTAssertEqual(clearChat.userLogin, "ronni")
    XCTAssertEqual(clearChat.banDuration, nil)
    XCTAssertEqual(clearChat.userIsPermanentlyBanned, true)
  }

  func testParsedValues3() throws {
    let string = "@ban-duration=3600 :tmi.twitch.tv CLEARCHAT #goodvibes :toxicity"
    let clearChat: ClearChat = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(clearChat.channel, "goodvibes")
    XCTAssertEqual(clearChat.userLogin, "toxicity")
    XCTAssertEqual(clearChat.banDuration, 3600)
    XCTAssertEqual(clearChat.userIsPermanentlyBanned, false)
  }
}
