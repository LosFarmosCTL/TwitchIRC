import XCTest

@testable import TwitchIRC

final class UserNoticeSubscriptionTests: XCTestCase {
  typealias Action = UserNotice.MessageID

  func testParsedValues1() throws {
    let string =
      #"@badge-info=;badges=staff/1,broadcaster/1,turbo/1;color=#008000;display-name=ronni;emotes=;id=db25007f-7a18-43eb-9379-80131e44d633;login=ronni;mod=0;msg-id=resub;msg-param-cumulative-months=6;msg-param-streak-months=2;msg-param-should-share-streak=1;msg-param-sub-plan=Prime;msg-param-sub-plan-name=Prime;room-id=1337;subscriber=1;system-msg=ronni\shas\ssubscribed\sfor\s6\smonths!;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=staff;vip=0 :tmi.twitch.tv USERNOTICE #dallas :Great stream -- keep it up!"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "dallas")
    XCTAssertEqual(userNotice.message, "Great stream -- keep it up!")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, ["staff/1", "broadcaster/1", "turbo/1"])
    XCTAssertEqual(userNotice.color, "#008000")
    XCTAssertEqual(userNotice.displayName, "ronni")
    XCTAssertEqual(userNotice.emotes, "")
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "db25007f-7a18-43eb-9379-80131e44d633")
    XCTAssertEqual(userNotice.userLogin, "ronni")
    XCTAssertEqual(userNotice.roomId, "1337")
    XCTAssertEqual(userNotice.systemMessage, #"ronni\shas\ssubscribed\sfor\s6\smonths!"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_507_246_572_675)
    XCTAssertEqual(userNotice.userId, "1337")
    XCTAssertEqual(userNotice.sourceMessageId, "")
    XCTAssertEqual(userNotice.source.id, "")
    XCTAssertEqual(userNotice.source.roomId, "")
    XCTAssertEqual(userNotice.source.badges, [])
    XCTAssertEqual(userNotice.source.badgeInfo, [])
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.ReSubInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.cumulativeMonths, 6)
    XCTAssertEqual(info.shouldShareStreak, true)
    XCTAssertEqual(info.streakMonths, 2)
    XCTAssertEqual(info.subPlan, .prime)
    XCTAssertEqual(info.subPlanName, "Prime")
    XCTAssertEqual(info.anonGift, false)
    XCTAssertEqual(info.months, 0)
    XCTAssertEqual(info.multimonthDuration, 0)
    XCTAssertEqual(info.multimonthTenure, false)
    XCTAssertEqual(info.wasGifted, false)
    XCTAssertEqual(info.giftMonthBeingRedeemed, 0)
    XCTAssertEqual(info.giftMonths, 0)
    XCTAssertEqual(info.gifterId, "")
    XCTAssertEqual(info.gifterLogin, "")
    XCTAssertEqual(info.gifterName, "")
  }
}
