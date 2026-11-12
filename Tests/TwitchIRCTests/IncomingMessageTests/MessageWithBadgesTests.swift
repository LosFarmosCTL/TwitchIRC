import XCTest

@testable import TwitchIRC

final class MessageWithBadgesTests: XCTestCase {

  func testAllTrue() throws {
    let message = MockMessageWithBadges(
      badges: [
        "global_mod/1",
        "moderator/1",
        "broadcaster/1",
        "subscriber/1",
        "vip/1",
        "turbo/1",
        "staff/1",
      ]
    )

    XCTAssertEqual(message.isMod, true)
    XCTAssertEqual(message.isSubscriber, true)
    XCTAssertEqual(message.isBroadcaster, true)
    XCTAssertEqual(message.isVIP, true)
    XCTAssertEqual(message.isTurbo, true)
    XCTAssertEqual(message.isStaff, true)
    XCTAssertEqual(message.isGlobalMod, true)
  }

  func testModeratorBadgeNames() {
    for badge in ["moderator/1", "lead_moderator/1", "lead_moderator/2"] {
      XCTAssertTrue(MockMessageWithBadges(badges: [badge]).isMod, badge)
    }
    for badge in ["moderator_extra/1", "lead_moderator_extra/1", "global_mod/1", "vip/1"] {
      XCTAssertFalse(MockMessageWithBadges(badges: [badge]).isMod, badge)
    }
  }

  func testLeadModeratorInSharedChatSource() {
    let source = SharedChatSource(id: "source", roomId: "channel", badges: ["lead_moderator/1"])
    XCTAssertTrue(source.isMod)
  }

  func testAllFalse() throws {
    let message = MockMessageWithBadges(badges: [])

    XCTAssertEqual(message.isMod, false)
    XCTAssertEqual(message.isSubscriber, false)
    XCTAssertEqual(message.isBroadcaster, false)
    XCTAssertEqual(message.isVIP, false)
    XCTAssertEqual(message.isTurbo, false)
    XCTAssertEqual(message.isStaff, false)
    XCTAssertEqual(message.isGlobalMod, false)
  }
}

private struct MockMessageWithBadges: MessageWithBadges {
  let badges: [String]
}
