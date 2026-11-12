import XCTest

@testable import TwitchIRC

final class UserNoticeGiftTests: XCTestCase {
  typealias Action = UserNotice.MessageID

  func testParsedValues2() throws {
    let string =
      #"@badge-info=;badges=staff/1,premium/1;color=#0000FF;display-name=TWW2;emotes=;id=e9176cd8-5e22-4684-ad40-ce53c2561c5e;login=tww2;mod=0;msg-id=subgift;msg-param-months=1;msg-param-recipient-display-name=Mr_Woodchuck;msg-param-recipient-id=89614178;msg-param-recipient-user-name=mr_woodchuck;msg-param-sub-plan-name=House\sof\sNyoro~n;msg-param-sub-plan=1000;room-id=19571752;subscriber=0;system-msg=TWW2\sgifted\sa\sTier\s1\ssub\sto\sMr_Woodchuck!;tmi-sent-ts=1521159445153;turbo=0;user-id=13405587;user-type=staff;vip=0 :tmi.twitch.tv USERNOTICE #forstycup"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "forstycup")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, ["staff/1", "premium/1"])
    XCTAssertEqual(userNotice.color, "#0000FF")
    XCTAssertEqual(userNotice.displayName, "TWW2")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "e9176cd8-5e22-4684-ad40-ce53c2561c5e")
    XCTAssertEqual(userNotice.userLogin, "tww2")
    XCTAssertEqual(userNotice.roomId, "19571752")
    XCTAssertEqual(userNotice.systemMessage, #"TWW2\sgifted\sa\sTier\s1\ssub\sto\sMr_Woodchuck!"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_521_159_445_153)
    XCTAssertEqual(userNotice.userId, "13405587")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.SubGiftInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.months, 1)
    XCTAssertEqual(info.recipientDisplayName, "Mr_Woodchuck")
    XCTAssertEqual(info.recipientId, "89614178")
    XCTAssertEqual(info.recipientUserName, "mr_woodchuck")
    XCTAssertEqual(info.subPlan, .tier1)
    XCTAssertEqual(info.subPlanName, #"House\sof\sNyoro~n"#)
    XCTAssertEqual(info.giftMonths, 0)
    XCTAssertEqual(info.originId, "")
    XCTAssertEqual(info.senderCount, 0)
    XCTAssertEqual(info.funString, "")
    XCTAssertEqual(info.giftTheme, "")
    XCTAssertEqual(info.goalContributionType, "")
    XCTAssertEqual(info.goalCurrentContributions, "")
    XCTAssertEqual(info.goalDescription, "")
    XCTAssertEqual(info.goalTargetContributions, "")
    XCTAssertEqual(info.goalUserContributions, "")
  }

  func testParsedValues3() throws {
    let string =
      #"@badge-info=;badges=broadcaster/1,subscriber/6;color=;display-name=qa_subs_partner;emotes=;flags=;id=b1818e3c-0005-490f-ad0a-804957ddd760;login=qa_subs_partner;mod=0;msg-id=anonsubgift;msg-param-months=3;msg-param-recipient-display-name=TenureCalculator;msg-param-recipient-id=135054130;msg-param-recipient-user-name=tenurecalculator;msg-param-sub-plan-name=t111;msg-param-sub-plan=1000;room-id=196450059;subscriber=1;system-msg=An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\sTenureCalculator!\s;tmi-sent-ts=1542063432068;turbo=0;user-id=196450059;vip=0;user-type= :tmi.twitch.tv USERNOTICE #qa_subs_partner"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "qa_subs_partner")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, ["broadcaster/1", "subscriber/6"])
    XCTAssertNil(userNotice.color)
    XCTAssertEqual(userNotice.displayName, "qa_subs_partner")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "b1818e3c-0005-490f-ad0a-804957ddd760")
    XCTAssertEqual(userNotice.userLogin, "qa_subs_partner")
    XCTAssertEqual(userNotice.roomId, "196450059")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\sTenureCalculator!\s"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_542_063_432_068)
    XCTAssertEqual(userNotice.userId, "196450059")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.SubGiftInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.months, 3)
    XCTAssertEqual(info.recipientDisplayName, "TenureCalculator")
    XCTAssertEqual(info.recipientId, "135054130")
    XCTAssertEqual(info.recipientUserName, "tenurecalculator")
    XCTAssertEqual(info.subPlan, .tier1)
    XCTAssertEqual(info.subPlanName, "t111")
    XCTAssertEqual(info.giftMonths, 0)
    XCTAssertEqual(info.originId, "")
    XCTAssertEqual(info.senderCount, 0)
    XCTAssertEqual(info.funString, "")
    XCTAssertEqual(info.giftTheme, "")
    XCTAssertEqual(info.goalContributionType, "")
    XCTAssertEqual(info.goalCurrentContributions, "")
    XCTAssertEqual(info.goalDescription, "")
    XCTAssertEqual(info.goalTargetContributions, "")
    XCTAssertEqual(info.goalUserContributions, "")
  }

  func testParsedValues8() throws {
    let string =
      #"@badge-info=;badges=;color=;display-name=AnAnonymousGifter;emotes=;flags=;id=fdfebaac-e54e-44c1-b81c-95fa2f4f6c73;login=ananonymousgifter;mod=0;msg-id=subgift;msg-param-fun-string=FunStringFive;msg-param-gift-months=1;msg-param-goal-contribution-type=SUB_POINTS;msg-param-goal-current-contributions=181;msg-param-goal-description=Kochen\s+\s69;msg-param-goal-target-contributions=299;msg-param-goal-user-contributions=1;msg-param-months=4;msg-param-origin-id=21\sc2\sd1\s0d\sc9\s61\s69\sa0\s2c\s73\sad\s42\sad\s79\s60\s5e\s72\sa5\s33\s6b;msg-param-recipient-display-name=rtg_richy;msg-param-recipient-id=645584945;msg-param-recipient-user-name=rtg_richy;msg-param-sub-plan-name=Channel\sSubscription\s(dennisrlf_);msg-param-sub-plan=1000;room-id=506507314;subscriber=0;system-msg=An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\srtg_richy!\s;tmi-sent-ts=1643135914821;user-id=274598607;user-type=;vip=1 :tmi.twitch.tv USERNOTICE #dennisrlf_"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "dennisrlf_")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, [])
    XCTAssertNil(userNotice.color)
    XCTAssertEqual(userNotice.displayName, "AnAnonymousGifter")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "fdfebaac-e54e-44c1-b81c-95fa2f4f6c73")
    XCTAssertEqual(userNotice.userLogin, "ananonymousgifter")
    XCTAssertEqual(userNotice.roomId, "506507314")
    XCTAssertEqual(
      userNotice.systemMessage, #"An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\srtg_richy!\s"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_643_135_914_821)
    XCTAssertEqual(userNotice.userId, "274598607")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.SubGiftInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.months, 4)
    XCTAssertEqual(info.recipientDisplayName, "rtg_richy")
    XCTAssertEqual(info.recipientId, "645584945")
    XCTAssertEqual(info.recipientUserName, "rtg_richy")
    XCTAssertEqual(info.subPlan, .tier1)
    XCTAssertEqual(info.subPlanName, #"Channel\sSubscription\s(dennisrlf_)"#)
    XCTAssertEqual(info.giftMonths, 1)
    XCTAssertEqual(
      info.originId,
      #"21\sc2\sd1\s0d\sc9\s61\s69\sa0\s2c\s73\sad\s42\sad\s79\s60\s5e\s72\sa5\s33\s6b"#)
    XCTAssertEqual(info.senderCount, 0)
    XCTAssertEqual(info.funString, "FunStringFive")
    XCTAssertEqual(info.giftTheme, "")
    XCTAssertEqual(info.goalContributionType, "SUB_POINTS")
    XCTAssertEqual(info.goalCurrentContributions, "181")
    XCTAssertEqual(info.goalDescription, #"Kochen\s+\s69"#)
    XCTAssertEqual(info.goalTargetContributions, "299")
    XCTAssertEqual(info.goalUserContributions, "1")
  }

  func testParsedValues9() throws {
    let string =
      #"@badge-info=;badges=;color=;display-name=AnAnonymousGifter;emotes=;flags=;id=a05bcefe-bcae-4421-899a-c2ed087d3174;login=ananonymousgifter;mod=0;msg-id=subgift;msg-param-fun-string=FunStringOne;msg-param-gift-months=1;msg-param-gift-theme=lul;msg-param-months=2;msg-param-origin-id=e0\sbf\sa4\s8d\se8\s49\s72\s6e\s37\s1f\s32\s62\s6c\s98\s53\s45\sf1\s34\s15\s3e;msg-param-recipient-display-name=professorlive_cr;msg-param-recipient-id=214715951;msg-param-recipient-user-name=professorlive_cr;msg-param-sub-plan-name=Juicy;msg-param-sub-plan=1000;room-id=123721524;subscriber=0;system-msg=An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\sprofessorlive_cr!\s;tmi-sent-ts=1643495894080;user-id=274598607;vip=1;user-type= :tmi.twitch.tv USERNOTICE #juicyj_cr"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "juicyj_cr")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.badges, [])
    XCTAssertNil(userNotice.color)
    XCTAssertEqual(userNotice.displayName, "AnAnonymousGifter")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "a05bcefe-bcae-4421-899a-c2ed087d3174")
    XCTAssertEqual(userNotice.userLogin, "ananonymousgifter")
    XCTAssertEqual(userNotice.roomId, "123721524")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\sprofessorlive_cr!\s"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_643_495_894_080)
    XCTAssertEqual(userNotice.userId, "274598607")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.SubGiftInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.months, 2)
    XCTAssertEqual(info.recipientDisplayName, "professorlive_cr")
    XCTAssertEqual(info.recipientId, "214715951")
    XCTAssertEqual(info.recipientUserName, "professorlive_cr")
    XCTAssertEqual(info.subPlan, .tier1)
    XCTAssertEqual(info.subPlanName, "Juicy")
    XCTAssertEqual(info.giftMonths, 1)
    XCTAssertEqual(
      info.originId,
      #"e0\sbf\sa4\s8d\se8\s49\s72\s6e\s37\s1f\s32\s62\s6c\s98\s53\s45\sf1\s34\s15\s3e"#)
    XCTAssertEqual(info.senderCount, 0)
    XCTAssertEqual(info.funString, "FunStringOne")
    XCTAssertEqual(info.giftTheme, "lul")
    XCTAssertEqual(info.goalContributionType, "")
    XCTAssertEqual(info.goalCurrentContributions, "")
    XCTAssertEqual(info.goalDescription, "")
    XCTAssertEqual(info.goalTargetContributions, "")
    XCTAssertEqual(info.goalUserContributions, "")
  }

  func testParsedValues15() throws {
    let string =
      #"@badge-info=subscriber/5;badges=subscriber/3,sub-gifter/10;color=;display-name=EABare;emotes=;flags=;id=aadbe3eb-7d44-46d9-a596-d2d45dbe5f68;login=eabare;mod=0;msg-id=subgift;msg-param-community-gift-id=b9\\s31\\s3e\\s61\\s1f\\s74\\sa1\\s59\\scc\\sa1\\sb7\\s96\\sbb\\sdb\\s8c\\s10\\sd9\\s90\\s68\\sea;msg-param-gift-months=1;msg-param-months=9;msg-param-origin-id=b9\\s31\\s3e\\s61\\s1f\\s74\\sa1\\s59\\scc\\sa1\\sb7\\s96\\sbb\\sdb\\s8c\\s10\\sd9\\s90\\s68\\sea;msg-param-recipient-display-name=josefernandezxc;msg-param-recipient-id=497056606;msg-param-recipient-user-name=josefernandezxc;msg-param-sender-count=0;msg-param-sub-plan-name=Channel\\sSubscription\\s(zsheli);msg-param-sub-plan=1000;room-id=54443609;subscriber=1;system-msg=EABare\\sgifted\\sa\\sTier\\s1\\ssub\\sto\\sjosefernandezxc!;tmi-sent-ts=1699496601758;user-id=816456923;user-type=;vip=0 :tmi.twitch.tv USERNOTICE #shellive"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "shellive")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, ["subscriber/5"])
    XCTAssertEqual(userNotice.badges, ["subscriber/3", "sub-gifter/10"])
    XCTAssertNil(userNotice.color)
    XCTAssertEqual(userNotice.displayName, "EABare")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "aadbe3eb-7d44-46d9-a596-d2d45dbe5f68")
    XCTAssertEqual(userNotice.userLogin, "eabare")
    XCTAssertEqual(userNotice.roomId, "54443609")
    XCTAssertEqual(
      userNotice.systemMessage,
      #"EABare\\sgifted\\sa\\sTier\\s1\\ssub\\sto\\sjosefernandezxc!"#
    )
    XCTAssertEqual(userNotice.tmiSentTs, 1_699_496_601_758)
    XCTAssertEqual(userNotice.userId, "816456923")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.SubGiftInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.months, 9)
    XCTAssertEqual(info.recipientDisplayName, "josefernandezxc")
    XCTAssertEqual(info.recipientId, "497056606")
    XCTAssertEqual(info.recipientUserName, "josefernandezxc")
    XCTAssertEqual(info.subPlan, .tier1)
    XCTAssertEqual(info.subPlanName, #"Channel\\sSubscription\\s(zsheli)"#)
    XCTAssertEqual(info.giftMonths, 1)
    XCTAssertEqual(
      info.originId,
      #"b9\\s31\\s3e\\s61\\s1f\\s74\\sa1\\s59\\scc\\sa1\\sb7\\s96\\sbb\\sdb\\s8c\\s10\\sd9\\s90\\s68\\sea"#
    )
    XCTAssertEqual(info.senderCount, 0)
    XCTAssertEqual(info.funString, "")
    XCTAssertEqual(info.giftTheme, "")
    XCTAssertEqual(info.goalContributionType, "")
    XCTAssertEqual(info.goalCurrentContributions, "")
    XCTAssertEqual(info.goalDescription, "")
    XCTAssertEqual(info.goalTargetContributions, "")
    XCTAssertEqual(info.goalUserContributions, "")
    XCTAssertEqual(
      info.communityGiftId,
      #"b9\\s31\\s3e\\s61\\s1f\\s74\\sa1\\s59\\scc\\sa1\\sb7\\s96\\sbb\\sdb\\s8c\\s10\\sd9\\s90\\s68\\sea"#
    )
  }
  func testParsedValues10() throws {
    let string =
      #"@badge-info=subscriber/1;badges=subscriber/0,sub-gifter/1;color=#8422B2;display-name=ItsMeekz;emotes=;flags=;id=0f138c82-d842-4055-af48-f7a84a43461d;login=itsmeekz;mod=0;msg-id=primepaidupgrade;msg-param-sub-plan=1000;room-id=117855516;subscriber=1;system-msg=ItsMeekz\sconverted\sfrom\sa\sPrime\ssub\sto\sa\sTier\s1\ssub!;tmi-sent-ts=1643569662528;vip=1;user-id=608094265;user-type= :tmi.twitch.tv USERNOTICE #domino_stein"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "domino_stein")
    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.badgeInfo, ["subscriber/1"])
    XCTAssertEqual(userNotice.badges, ["subscriber/0", "sub-gifter/1"])
    XCTAssertEqual(userNotice.color, "#8422B2")
    XCTAssertEqual(userNotice.displayName, "ItsMeekz")
    XCTAssertEqual(userNotice.emotes, [])
    XCTAssertEqual(userNotice.flags, [])
    XCTAssertEqual(userNotice.id, "0f138c82-d842-4055-af48-f7a84a43461d")
    XCTAssertEqual(userNotice.userLogin, "itsmeekz")
    XCTAssertEqual(userNotice.roomId, "117855516")
    XCTAssertEqual(
      userNotice.systemMessage, #"ItsMeekz\sconverted\sfrom\sa\sPrime\ssub\sto\sa\sTier\s1\ssub!"#)
    XCTAssertEqual(userNotice.tmiSentTs, 1_643_569_662_528)
    XCTAssertEqual(userNotice.userId, "608094265")
    XCTAssertTrue(
      userNotice.parsingLeftOvers.isEmpty,
      "Non-empty parsing left-overs: \(userNotice.parsingLeftOvers)")

    let info: Action.PrimePaidUpgradeInfo = try unwrapInnerValue(action: userNotice.messageId)

    XCTAssertEqual(info.subPlan, .tier1)
  }
}
