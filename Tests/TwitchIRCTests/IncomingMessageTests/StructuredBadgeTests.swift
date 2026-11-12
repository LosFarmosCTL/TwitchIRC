import XCTest

@testable import TwitchIRC

final class StructuredBadgeTests: XCTestCase {
  func testBadgeVersionsAndMetadataRemainDistinct() {
    var parser = ParametersParser(
      "badges=subscriber/0,future-badge/blue-1;badge-info=subscriber/30,predictions/Team/Blue")
    XCTAssertEqual(
      parser.badges(),
      [
        Badge(setID: "subscriber", version: "0"),
        Badge(setID: "future-badge", version: "blue-1"),
      ])
    XCTAssertEqual(
      parser.badgeInfo(),
      [
        BadgeInfo(setID: "subscriber", value: "30"),
        BadgeInfo(setID: "predictions", value: "Team/Blue"),
      ])
    XCTAssertTrue(parser.getLeftOvers().isEmpty)
  }

  func testMalformedEntriesProduceDiagnosticsWithoutLosingValidBadges() {
    var parser = ParametersParser("badges=bad,/1,staff/,vip/1;badge-info=subscriber/20,broken")
    XCTAssertEqual(parser.badges(), [Badge(setID: "vip", version: "1")])
    XCTAssertEqual(parser.badgeInfo(), [BadgeInfo(setID: "subscriber", value: "20")])
    XCTAssertEqual(parser.getLeftOvers().unparsedKeys.count, 4)
  }

  func testSharedChatKeepsSourceBadgesSeparate() throws {
    var parser = ParametersParser(
      "source-badges=lead_moderator/1;source-badge-info=subscriber/12;badges=vip/1")
    let source = try XCTUnwrap(SharedChatSource(parser: &parser))
    XCTAssertTrue(source.isMod)
    XCTAssertEqual(source.badgeInfo, [BadgeInfo(setID: "subscriber", value: "12")])
    XCTAssertEqual(parser.badges(), [Badge(setID: "vip", version: "1")])
  }

  func testRoleChecksMatchExactSets() {
    let source = SharedChatSource(
      id: nil, roomId: nil,
      badges: ["subscriber_extra", "vip_extra", "staff_extra", "broadcaster_extra"].map {
        Badge(setID: $0, version: "1")
      })
    XCTAssertFalse(source.isSubscriber)
    XCTAssertFalse(source.isVIP)
    XCTAssertFalse(source.isStaff)
    XCTAssertFalse(source.isBroadcaster)
  }
}
