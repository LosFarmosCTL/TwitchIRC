import XCTest

@testable import TwitchIRC

final class UserNoticeEventTests: XCTestCase {
  typealias Action = UserNotice.Kind

  func testParsedValues11() throws {
    let string =
      #"@badge-info=subscriber/44;badges=broadcaster/1,subscriber/3036,partner/1;color=#8A2BE2;display-name=Schlonsti;emotes=;flags=;id=0d011cb5-84c9-4abf-b469-905fa48d1e73;login=schlonsti;mod=0;msg-id=announcement;msg-param-color=PRIMARY;room-id=90968980;subscriber=1;system-msg=;tmi-sent-ts=1648760291007;user-id=90968980;vip=1;user-type= :tmi.twitch.tv USERNOTICE #schlonsti :fehler"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "schlonsti")
    XCTAssertEqual(userNotice.message, "fehler")
    XCTAssertEqual(userNotice.badgeInfo, [BadgeInfo(setID: "subscriber", value: "44")])
    XCTAssertEqual(
      userNotice.badges,
      [
        Badge(setID: "broadcaster", version: "1"), Badge(setID: "subscriber", version: "3036"),
        Badge(setID: "partner", version: "1"),
      ])
    XCTAssertEqual(userNotice.color, "#8A2BE2")
    XCTAssertEqual(userNotice.displayName, "Schlonsti")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "0d011cb5-84c9-4abf-b469-905fa48d1e73")
    XCTAssertEqual(userNotice.userLogin, "schlonsti")
    XCTAssertEqual(userNotice.roomID, "90968980")
    XCTAssertEqual(userNotice.systemMessage, "")
    XCTAssertEqual(userNotice.timestampMilliseconds, 1_648_760_291_007)
    XCTAssertEqual(userNotice.userID, "90968980")
    XCTAssertTrue(
      userNotice.parsingLeftovers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftovers)")

    let infoColor: String = try unwrapInnerValue(action: userNotice.kind)

    XCTAssertEqual(infoColor, "PRIMARY")
  }

  func testParsedValues12() throws {
    let string =
      #"@badge-info=;badges=;color=#DAA520;display-name=LF_patocarlo_papi;emotes=;flags=;id=9734d325-603f-42a8-a728-2032943d1786;login=lf_patocarlo_papi;mod=0;msg-id=midnightsquid;msg-param-amount=100;msg-param-currency=USD;msg-param-emote-id=emotesv2_630d12043c5d40dc97a1f8deac5842f1;msg-param-exponent=2;msg-param-is-highlighted=false;msg-param-pill-type=Success;room-id=473386056;subscriber=0;system-msg=LF_patocarlo_papi\\sCheered\\swith\\s$1.00;tmi-sent-ts=1664487028027;user-id=494211968;vip=1;user-type= :tmi.twitch.tv USERNOTICE #jandrotc"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "jandrotc")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, [])
    XCTAssertEqual(userNotice.color, "#DAA520")
    XCTAssertEqual(userNotice.displayName, "LF_patocarlo_papi")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "9734d325-603f-42a8-a728-2032943d1786")
    XCTAssertEqual(userNotice.userLogin, "lf_patocarlo_papi")
    XCTAssertEqual(userNotice.roomID, "473386056")
    XCTAssertEqual(userNotice.systemMessage, #"LF_patocarlo_papi\\sCheered\\swith\\s$1.00"#)
    XCTAssertEqual(userNotice.timestampMilliseconds, 1_664_487_028_027)
    XCTAssertEqual(userNotice.userID, "494211968")
    XCTAssertTrue(
      userNotice.parsingLeftovers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftovers)")

    let info: Action.MidnightSquidInfo = try unwrapInnerValue(action: userNotice.kind)

    XCTAssertEqual(info.amount, 100)
    XCTAssertEqual(info.currency, "USD")
    XCTAssertEqual(info.emoteID, "emotesv2_630d12043c5d40dc97a1f8deac5842f1")
    XCTAssertEqual(info.exponent, 2)
    XCTAssertEqual(info.isHighlighted, false)
    XCTAssertEqual(info.pillType, "Success")
  }

  func testParsedValues13() throws {
    let string =
      #"@badge-info=;badges=premium/1;color=#9ACD32;display-name=LukeCaboom;emotes=;flags=;id=479defa1-dac0-47e6-b308-a19c2a8b64cd;login=lukecaboom;mod=0;msg-id=charitydonation;msg-param-charity-name=Wounded\\sWarrior\\sProject;msg-param-donation-amount=500;msg-param-donation-currency=USD;msg-param-exponent=2;room-id=18798485;subscriber=0;system-msg=LukeCaboom:\\sDonated\\sUSD\\s5\\sto\\ssupport\\sWounded\\sWarrior\\sProject;tmi-sent-ts=1664727225702;user-id=514556756;vip=1;user-type= :tmi.twitch.tv USERNOTICE #fxyen"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "fxyen")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, [Badge(setID: "premium", version: "1")])
    XCTAssertEqual(userNotice.color, "#9ACD32")
    XCTAssertEqual(userNotice.displayName, "LukeCaboom")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "479defa1-dac0-47e6-b308-a19c2a8b64cd")
    XCTAssertEqual(userNotice.userLogin, "lukecaboom")
    XCTAssertEqual(userNotice.roomID, "18798485")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"LukeCaboom:\\sDonated\\sUSD\\s5\\sto\\ssupport\\sWounded\\sWarrior\\sProject"#
    )
    XCTAssertEqual(userNotice.timestampMilliseconds, 1_664_727_225_702)
    XCTAssertEqual(userNotice.userID, "514556756")
    XCTAssertTrue(
      userNotice.parsingLeftovers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftovers)")

    let info: Action.CharityDonationInfo = try unwrapInnerValue(action: userNotice.kind)

    XCTAssertEqual(info.charityName, #"Wounded\\sWarrior\\sProject"#)
    XCTAssertEqual(info.amount, 500)
    XCTAssertEqual(info.currency, "USD")
    XCTAssertEqual(info.exponent, 2)
  }

  func testParsedValues14() throws {
    let string =
      #"@badge-info=founder/12;badges=moderator/1,founder/0,hype-train/1;color=#0000FF;display-name=metalkiller354;emotes=;flags=;id=aa1d37a5-e0d0-40b2-b374-ae779896a6f9;login=metalkiller354;mod=1;msg-id=viewermilestone;msg-param-category=watch-streak;msg-param-id=f05b2393-3bee-451c-bcb2-d12ea06781d7;msg-param-value=3;room-id=442187430;msg-param-copoReward=450;subscriber=1;system-msg=metalkiller354\\swatched\\s3\\sconsecutive\\sstreams\\sthis\\smonth\\sand\\ssparked\\sa\\swatch\\sstreak!;tmi-sent-ts=1678130127599;user-id=224637183;vip=1;user-type=mod :tmi.twitch.tv USERNOTICE #tryaz"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "tryaz")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [BadgeInfo(setID: "founder", value: "12")])
    XCTAssertEqual(
      userNotice.badges,
      [
        Badge(setID: "moderator", version: "1"), Badge(setID: "founder", version: "0"),
        Badge(setID: "hype-train", version: "1"),
      ])
    XCTAssertEqual(userNotice.color, "#0000FF")
    XCTAssertEqual(userNotice.displayName, "metalkiller354")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "aa1d37a5-e0d0-40b2-b374-ae779896a6f9")
    XCTAssertEqual(userNotice.userLogin, "metalkiller354")
    XCTAssertEqual(userNotice.roomID, "442187430")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"metalkiller354\\swatched\\s3\\sconsecutive\\sstreams\\sthis\\smonth\\sand\\ssparked\\sa\\swatch\\sstreak!"#
    )
    XCTAssertEqual(userNotice.timestampMilliseconds, 1_678_130_127_599)
    XCTAssertEqual(userNotice.userID, "224637183")
    XCTAssertTrue(
      userNotice.parsingLeftovers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftovers)")

    let info: Action.ViewerMilestoneInfo = try unwrapInnerValue(action: userNotice.kind)

    XCTAssertEqual(info.category, "watch-streak")
    XCTAssertEqual(info.id, "f05b2393-3bee-451c-bcb2-d12ea06781d7")
    XCTAssertEqual(info.value, 3)
    XCTAssertEqual(info.channelPointsReward, 450)
  }
}
