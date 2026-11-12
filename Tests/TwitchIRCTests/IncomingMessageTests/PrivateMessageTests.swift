import XCTest

@testable import TwitchIRC

final class PrivateMessageTests: XCTestCase {

  func testParsedValues1() throws {
    let string =
      "@badge-info=;badges=global_mod/1,turbo/1;color=#0D4200;display-name=ronni;emotes=25:0-4,12-16/1902:6-10;id=b34ccfc7-4977-403a-8a94-33c6bac34fb8;mod=0;room-id=1337;subscriber=0;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=global_mod :ronni!ronni@ronni.tmi.twitch.tv PRIVMSG #ronni :Kappa Keepo Kappa"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    let parsedEmotes: [Emote] = [
      .init(id: "25", name: "Kappa", startIndex: 0, endIndex: 4),
      .init(id: "25", name: "Kappa", startIndex: 12, endIndex: 16),
      .init(id: "1902", name: "Keepo", startIndex: 6, endIndex: 10),
    ]

    XCTAssertEqual(msg.channel, "ronni")
    XCTAssertEqual(msg.message, "Kappa Keepo Kappa")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, ["global_mod/1", "turbo/1"])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#0D4200")
    XCTAssertEqual(msg.displayName, "ronni")
    XCTAssertEqual(msg.userLogin, "ronni")
    XCTAssertEqual(msg.emotes, "25:0-4,12-16/1902:6-10")
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertNil(msg.firstMessage)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "b34ccfc7-4977-403a-8a94-33c6bac34fb8")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "1337")
    XCTAssertEqual(msg.tmiSentTs, 1_507_246_572_675)
    XCTAssertNil(msg.clientNonce)
    XCTAssertEqual(msg.userId, "1337")
    XCTAssertNil(msg.source)
    XCTAssertNil(msg.sourceOnly)
    XCTAssertNil(msg.replyParent)
    XCTAssertEqual(msg.parseEmotes(), parsedEmotes)

    XCTAssertTrue(msg.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
  }

  func testParsedValues2() throws {
    let string =
      "@badge-info=;badges=staff/1,bits/1000;bits=100;color=;display-name=ronni;emotes=;id=b34ccfc7-4977-403a-8a94-33c6bac34fb8;mod=0;room-id=1337;subscriber=0;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=staff :ronni!ronni@ronni.tmi.twitch.tv PRIVMSG #ronni :cheer100"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "ronni")
    XCTAssertEqual(msg.message, "cheer100")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, ["staff/1", "bits/1000"])
    XCTAssertEqual(msg.bits, "100")
    XCTAssertNil(msg.color)
    XCTAssertEqual(msg.displayName, "ronni")
    XCTAssertEqual(msg.userLogin, "ronni")
    XCTAssertEqual(msg.emotes, "")
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertNil(msg.firstMessage)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "b34ccfc7-4977-403a-8a94-33c6bac34fb8")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "1337")
    XCTAssertEqual(msg.tmiSentTs, 1_507_246_572_675)
    XCTAssertNil(msg.clientNonce)
    XCTAssertEqual(msg.userId, "1337")
    XCTAssertNil(msg.replyParent)

    XCTAssertTrue(msg.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
  }

  func testParsedValues3() throws {
    let string =
      "@badge-info=;badges=;client-nonce=3dc1eef952878c31098361ebfc5017d7;color=;display-name=littlesnakysnake;emotes=;first-msg=0;flags=;id=9a323937-80fe-442a-b3a9-8c32e37cfb4f;mod=0;room-id=180980116;subscriber=0;tmi-sent-ts=1642848914241;turbo=0;user-id=478769067;user-type= :littlesnakysnake!littlesnakysnake@littlesnakysnake.tmi.twitch.tv PRIVMSG #carl_the_legend :ّ"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "carl_the_legend")
    XCTAssertEqual(msg.message, "ّ")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, [])
    XCTAssertNil(msg.bits)
    XCTAssertNil(msg.color)
    XCTAssertEqual(msg.displayName, "littlesnakysnake")
    XCTAssertEqual(msg.userLogin, "littlesnakysnake")
    XCTAssertEqual(msg.emotes, "")
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "9a323937-80fe-442a-b3a9-8c32e37cfb4f")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "180980116")
    XCTAssertEqual(msg.tmiSentTs, 1_642_848_914_241)
    XCTAssertEqual(msg.clientNonce, "3dc1eef952878c31098361ebfc5017d7")
    XCTAssertEqual(msg.userId, "478769067")
    XCTAssertNil(msg.replyParent)

    XCTAssertTrue(msg.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
  }

  func testParsedValues5() throws {
    let string =
      "@badge-info=;badges=;client-nonce=fa05d91c0394473736a56399f18b4d72;color=#19B330;crowd-chant-parent-msg-id=2bcffcc6-b9c7-4cf0-aef1-67ea8dbd60e3;display-name=TheHunterChamp;emotes=;first-msg=1;flags=;id=e1200eb4-8815-42bf-803f-a118deffe669;mod=0;room-id=139078933;subscriber=0;tmi-sent-ts=1643759403569;turbo=0;user-id=167448427;user-type= :thehunterchamp!thehunterchamp@thehunterchamp.tmi.twitch.tv PRIVMSG #xopxsam :PUSHIN 🅿️ TriDance"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "xopxsam")
    XCTAssertEqual(msg.message, "PUSHIN 🅿️ TriDance")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, [])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#19B330")
    XCTAssertEqual(msg.displayName, "TheHunterChamp")
    XCTAssertEqual(msg.userLogin, "thehunterchamp")
    XCTAssertEqual(msg.emotes, "")
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, true)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "e1200eb4-8815-42bf-803f-a118deffe669")
    XCTAssertEqual(msg.crowdChantParentMessageId, "2bcffcc6-b9c7-4cf0-aef1-67ea8dbd60e3")
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "139078933")
    XCTAssertEqual(msg.tmiSentTs, 1_643_759_403_569)
    XCTAssertEqual(msg.clientNonce, "fa05d91c0394473736a56399f18b4d72")
    XCTAssertEqual(msg.userId, "167448427")
    XCTAssertNil(msg.replyParent)

    XCTAssertTrue(msg.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
  }

  func testParsedValues6() throws {
    let string =
      "@badge-info=;badges=;client-nonce=915d8fd68f216eedc4f6b4aeea9e0f1b;color=#FF69B4;display-name=건조한갱생거북;emotes=;first-msg=0;flags=;id=df123fb2-4ff9-4dcc-bee0-740f4ac0e085;mod=0;room-id=198860406;subscriber=0;tmi-sent-ts=1645799365193;turbo=0;user-id=434919515;user-type= :newturtle_timi!newturtle_timi@newturtle_timi.tmi.twitch.tv PRIVMSG #berry0314 :ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "berry0314")
    XCTAssertEqual(msg.message, "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, [])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#FF69B4")
    XCTAssertEqual(msg.displayName, "건조한갱생거북")
    XCTAssertEqual(msg.userLogin, "newturtle_timi")
    XCTAssertEqual(msg.emotes, "")
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "df123fb2-4ff9-4dcc-bee0-740f4ac0e085")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "198860406")
    XCTAssertEqual(msg.tmiSentTs, 1_645_799_365_193)
    XCTAssertEqual(msg.clientNonce, "915d8fd68f216eedc4f6b4aeea9e0f1b")
    XCTAssertEqual(msg.userId, "434919515")
    XCTAssertNil(msg.replyParent)

    XCTAssertTrue(msg.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
  }

  func testParsedValues7() throws {
    let string =
      "@badge-info=;badges=vip/1;color=#0000FF;display-name=flexvegapro3;emotes=;first-msg=0;flags=;id=9c3e3024-a4b4-493b-8668-96597be002ac;mod=0;returning-chatter=0;room-id=550217406;subscriber=0;tmi-sent-ts=1655439139118;turbo=0;user-id=705215697;user-type= :flexvegapro3!flexvegapro3@flexvegapro3.tmi.twitch.tv PRIVMSG #novastark_7 :jajaja xD"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "novastark_7")
    XCTAssertEqual(msg.message, "jajaja xD")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, ["vip/1"])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#0000FF")
    XCTAssertEqual(msg.displayName, "flexvegapro3")
    XCTAssertEqual(msg.userLogin, "flexvegapro3")
    XCTAssertEqual(msg.emotes, "")
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertEqual(msg.returningChatter, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "9c3e3024-a4b4-493b-8668-96597be002ac")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "550217406")
    XCTAssertEqual(msg.tmiSentTs, 1_655_439_139_118)
    XCTAssertNil(msg.clientNonce)
    XCTAssertEqual(msg.userId, "705215697")
    XCTAssertNil(msg.replyParent)
    XCTAssertTrue(
      msg.parsingLeftOvers.isEmpty, "Non-empty parsing left-overs: \(msg.parsingLeftOvers)")
  }
}
