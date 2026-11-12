import XCTest

@testable import TwitchIRC

final class UserNoticeCommunityTests: XCTestCase {
  typealias Action = UserNotice.MessageID

  func testParsedValues4() throws {
    let string =
      #"@badge-info=;badges=turbo/1;color=#9ACD32;display-name=TestChannel;emotes=;id=3d830f12-795c-447d-af3c-ea05e40fbddb;login=testchannel;mod=0;msg-id=raid;msg-param-displayName=TestChannel;msg-param-login=testchannel;msg-param-viewerCount=15;room-id=56379257;subscriber=0;system-msg=15\sraiders\sfrom\sTestChannel\shave\sjoined\n!;tmi-sent-ts=1507246572675;turbo=1;user-id=123456;user-type=;vip=0 :tmi.twitch.tv USERNOTICE #othertestchannel"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "othertestchannel")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, ["turbo/1"])
    XCTAssertEqual(userNotice.color, "#9ACD32")
    XCTAssertEqual(userNotice.displayName, "TestChannel")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "3d830f12-795c-447d-af3c-ea05e40fbddb")
    XCTAssertEqual(userNotice.userLogin, "testchannel")
    XCTAssertEqual(userNotice.roomId, "56379257")
    XCTAssertEqual(userNotice.systemMessage, #"15\sraiders\sfrom\sTestChannel\shave\sjoined\n!"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_507_246_572_675)
    XCTAssertEqual(userNotice.userId, "123456")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.RaidInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.displayName, "TestChannel")
    XCTAssertEqual(info.login, "testchannel")
    XCTAssertEqual(info.viewerCount, 15)
    XCTAssertEqual(info.profileImageURL, "")
  }

  func testParsedValues5() throws {
    let string =
      #"@badge-info=;badges=;color=;display-name=SevenTest1;emotes=30259:0-6;id=37feed0f-b9c7-4c3a-b475-21c6c6d21c3d;login=seventest1;mod=0;msg-id=ritual;msg-param-ritual-name=new_chatter;room-id=6316121;subscriber=0;system-msg=Seventoes\sis\snew\shere!;tmi-sent-ts=1508363903826;turbo=0;user-id=131260580;user-type=;vip=1 :tmi.twitch.tv USERNOTICE #seventoes :HeyGuys"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "seventoes")
    XCTAssertEqual(userNotice.message, "HeyGuys")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, [])
    XCTAssertNil(userNotice.color)
    XCTAssertEqual(userNotice.displayName, "SevenTest1")
    XCTAssertEqual(userNotice.emotes, expectedEmotes("30259:0-6", in: userNotice.message))
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "37feed0f-b9c7-4c3a-b475-21c6c6d21c3d")
    XCTAssertEqual(userNotice.userLogin, "seventest1")
    XCTAssertEqual(userNotice.roomId, "6316121")
    XCTAssertEqual(userNotice.systemMessage, #"Seventoes\sis\snew\shere!"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_508_363_903_826)
    XCTAssertEqual(userNotice.userId, "131260580")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let ritualName: String = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(ritualName, "new_chatter")
  }

  func testParsedValues6() throws {
    let string =
      #"@badge-info=subscriber/1;badges=vip/1,subscriber/0,bits/100;color=#8A2BE2;display-name=pazza_cr4;emotes=;flags=;id=41ab23ee-4728-4f8b-9d72-8fa92300cc94;login=pazza_cr4;mod=0;msg-id=communitypayforward;msg-param-prior-gifter-anonymous=false;msg-param-prior-gifter-display-name=dillydilby;msg-param-prior-gifter-id=629935431;msg-param-prior-gifter-user-name=dillydilby;room-id=629935431;subscriber=1;system-msg=pazza_cr4\sis\spaying\sforward\sthe\sGift\sthey\sgot\sfrom\sdillydilby\sto\sthe\scommunity!;tmi-sent-ts=1642853857868;user-id=757980712;user-type=;vip=0 :tmi.twitch.tv USERNOTICE #dillydilby"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "dillydilby")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, ["subscriber/1"])
    XCTAssertEqual(userNotice.badges, ["vip/1", "subscriber/0", "bits/100"])
    XCTAssertEqual(userNotice.color, "#8A2BE2")
    XCTAssertEqual(userNotice.displayName, "pazza_cr4")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "41ab23ee-4728-4f8b-9d72-8fa92300cc94")
    XCTAssertEqual(userNotice.userLogin, "pazza_cr4")
    XCTAssertEqual(userNotice.roomId, "629935431")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"pazza_cr4\sis\spaying\sforward\sthe\sGift\sthey\sgot\sfrom\sdillydilby\sto\sthe\scommunity!"#
    )
    XCTAssertEqual(userNotice.tmiSentTs, 1_642_853_857_868)
    XCTAssertEqual(userNotice.userId, "757980712")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.CommunityPayForwardInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.priorGifterAnonymous, false)
    XCTAssertEqual(info.priorGifterDisplayName, "dillydilby")
    XCTAssertEqual(info.priorGifterId, "629935431")
    XCTAssertEqual(info.priorGifterUserName, "dillydilby")
  }

  func testParsedValues7() throws {
    let string =
      #"@badge-info=subscriber/13;badges=subscriber/12,glitchcon2020/1;color=#1E90FF;display-name=GissihatHunger;emotes=;flags=;id=4417af02-11f7-4da8-8118-8fc2913b841c;login=gissihathunger;mod=0;msg-id=standardpayforward;msg-param-prior-gifter-anonymous=false;msg-param-prior-gifter-display-name=Benenator_007;msg-param-prior-gifter-id=609956744;msg-param-prior-gifter-user-name=benenator_007;msg-param-recipient-display-name=cuteMaggi;msg-param-recipient-id=693345558;msg-param-recipient-user-name=cutemaggi;room-id=180980116;subscriber=1;system-msg=GissihatHunger\sis\spaying\sforward\sthe\sGift\sthey\sgot\sfrom\sBenenator_007\sto\scuteMaggi!;tmi-sent-ts=1642857017198;user-id=449423975;user-type=;vip=1 :tmi.twitch.tv USERNOTICE #carl_the_legend"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "carl_the_legend")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, ["subscriber/13"])
    XCTAssertEqual(userNotice.badges, ["subscriber/12", "glitchcon2020/1"])
    XCTAssertEqual(userNotice.color, "#1E90FF")
    XCTAssertEqual(userNotice.displayName, "GissihatHunger")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "4417af02-11f7-4da8-8118-8fc2913b841c")
    XCTAssertEqual(userNotice.userLogin, "gissihathunger")
    XCTAssertEqual(userNotice.roomId, "180980116")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"GissihatHunger\sis\spaying\sforward\sthe\sGift\sthey\sgot\sfrom\sBenenator_007\sto\scuteMaggi!"#
    )
    XCTAssertEqual(userNotice.tmiSentTs, 1_642_857_017_198)
    XCTAssertEqual(userNotice.userId, "449423975")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.StandardPayForwardInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.priorGifterAnonymous, false)
    XCTAssertEqual(info.priorGifterDisplayName, "Benenator_007")
    XCTAssertEqual(info.priorGifterId, "609956744")
    XCTAssertEqual(info.priorGifterUserName, "benenator_007")
    XCTAssertEqual(info.recipientDisplayName, "cuteMaggi")
    XCTAssertEqual(info.recipientId, "693345558")
    XCTAssertEqual(info.recipientUserName, "cutemaggi")
  }
}
