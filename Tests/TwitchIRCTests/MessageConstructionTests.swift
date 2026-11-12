import TwitchIRC
import XCTest

// Deliberately import without @testable: these constructors must work for library clients.
final class MessageConstructionTests: XCTestCase {
  func testRequiredNoticeAndHostPayloads() {
    let notice = Notice(kind: .global(message: "Connected"))
    let kind: Notice.Kind = notice.kind
    guard case .global(let text) = kind else { return XCTFail("Expected a global notice") }
    XCTAssertEqual(text, "Connected")

    let host = HostTarget(channel: "channel", action: .start(hostedChannel: "target"))
    let action: HostTarget.Action = host.action
    guard case .start(let channel) = action else { return XCTFail("Expected a host action") }
    XCTAssertEqual(channel, "target")
  }

  func testMinimalPrivateMessageConstruction() {
    let message = PrivateMessage(
      channel: "channel", message: "Hello", userLogin: "viewer",
      id: "message", roomId: "room", userId: "user")
    XCTAssertNil(message.replyParent)
    XCTAssertNil(message.replyThreadParent)
    XCTAssertNil(message.pinnedChat)
    XCTAssertNil(message.source)
    XCTAssertNil(message.tmiSentTs)
  }

  func testPublicUserNoticeConstruction() {
    let notice = UserNotice(
      channel: "channel", id: "message", userLogin: "moderator",
      messageId: .modiversary(.init(months: 12)), rawMessageId: "modiversary",
      roomId: "room", source: .init(id: "source", roomId: "room"), userId: "user")
    let category: UserNotice.MessageID = notice.messageId
    guard case .modiversary(let anniversary) = category else {
      return XCTFail("Expected a Modiversary payload")
    }
    XCTAssertEqual(anniversary.months, 12)
    XCTAssertEqual(notice.channel, "channel")
  }
}
