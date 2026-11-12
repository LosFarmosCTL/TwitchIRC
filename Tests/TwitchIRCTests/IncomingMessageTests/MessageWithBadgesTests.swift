import XCTest

@testable import TwitchIRC

final class MessageWithBadgesTests: XCTestCase {

  func testAllTrue() throws {
    let message = MockMessageWithBadges(
      badges: [
        Badge(setID: "global_mod", version: "1"),
        Badge(setID: "moderator", version: "1"),
        Badge(setID: "broadcaster", version: "1"),
        Badge(setID: "subscriber", version: "1"),
        Badge(setID: "vip", version: "1"),
        Badge(setID: "turbo", version: "1"),
        Badge(setID: "staff", version: "1"),
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
      XCTAssertTrue(
        MockMessageWithBadges(badges: [
          Badge(setID: String(badge.split(separator: "/")[0]), version: "1")
        ]).isMod, badge)
    }
    for badge in ["moderator_extra/1", "lead_moderator_extra/1", "global_mod/1", "vip/1"] {
      XCTAssertFalse(
        MockMessageWithBadges(badges: [
          Badge(setID: String(badge.split(separator: "/")[0]), version: "1")
        ]).isMod, badge)
    }
  }

  func testLeadModeratorInSharedChatSource() {
    let source = SharedChatSource(
      id: "source", roomID: "channel", badges: [Badge(setID: "lead_moderator", version: "1")])
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
  let badges: [Badge]
}
