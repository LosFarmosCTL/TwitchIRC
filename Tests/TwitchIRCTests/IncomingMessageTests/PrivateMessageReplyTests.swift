import XCTest

@testable import TwitchIRC

final class PrivateMessageReplyTests: XCTestCase {

  func testParsedValues4() throws {
    let string =
      "@badge-info=;badges=moderator/1;client-nonce=00e8c3279eebbb43ad80273324e10d28;color=#1E90FF;display-name=MahdiMMBM;emotes=;first-msg=0;flags=;id=7fd9a2fa-d537-4a31-b847-7e081c4c088d;mod=1;reply-parent-display-name=jay_999666;reply-parent-msg-body=!gc;reply-parent-msg-id=92d75439-9bfa-42d2-b20c-7dc4a2c07f6b;reply-parent-user-id=621834053;reply-parent-user-login=jay_999666;room-id=751562865;subscriber=0;tmi-sent-ts=1642084941607;turbo=0;user-id=519827148;user-type=mod :mahdimmbm!mahdimmbm@mahdimmbm.tmi.twitch.tv PRIVMSG #mohamedlightcr :@jay_999666 !gcs"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "mohamedlightcr")
    XCTAssertEqual(msg.message, "@jay_999666 !gcs")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, ["moderator/1"])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#1E90FF")
    XCTAssertEqual(msg.displayName, "MahdiMMBM")
    XCTAssertEqual(msg.userLogin, "mahdimmbm")
    XCTAssertEqual(msg.emotes, [])
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "7fd9a2fa-d537-4a31-b847-7e081c4c088d")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "751562865")
    XCTAssertEqual(msg.tmiSentTs, 1_642_084_941_607)
    XCTAssertEqual(msg.clientNonce, "00e8c3279eebbb43ad80273324e10d28")
    XCTAssertEqual(msg.userId, "519827148")
    XCTAssertTrue(
      try XCTUnwrap(msg.replyParent)
        == .init(
          displayName: "jay_999666",
          userLogin: "jay_999666",
          message: "!gc",
          id: "92d75439-9bfa-42d2-b20c-7dc4a2c07f6b",
          userId: "621834053"
        ))

    XCTAssertTrue(msg.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
  }

  func testParsedValues9() throws {
    let string =
      #"@badge-info=predictions/Pompeyo;badges=predictions/blue-1,premium/1;client-nonce=c5639d11fdac91cad488f52a0c0a927a;color=#FFF200;display-name=fladhi;emotes=;first-msg=0;flags=;id=c96d75f7-6fe0-41d0-bd27-80643426613c;mod=0;reply-parent-display-name=RoyaleAlchemist;reply-parent-msg-body=Clash\sRoyale\sAPI\sestá\sde\svuelta\sPogChamp\sPogChamp\s.\sSi\shubo\sun\smantenimiento\so\suna\sinterrupción\sdel\sservicio,\sya\sdebería\shaber\sterminado.\sRoyale\sAlchemist\snecesitará\sentre\s5\sy\s1     0\sminutos\spara\srecuperarse\spor\scompleto\s|\s@Pompeyo4;reply-parent-msg-id=0e772349-8bcd-42cb-9c91-1c9eece83af8;reply-parent-user-id=684111155;reply-parent-user-login=royalealchemist;reply-thread-parent-msg-id=0e772349-8bcd-42cb-9c91-1c9eece83af8;reply-thread-parent-user-login=royalealchemist;returning-chatter=0;room-id=118220323;subscriber=0;tmi-sent-ts=1687334511793;turbo=0;user-id=686358047;user-type= :fladhi!fladhi@fladhi.tmi.twitch.tv PRIVMSG #pompeyo4 :@RoyaleAlchemist whoAsked"#

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "pompeyo4")
    XCTAssertEqual(msg.message, "@RoyaleAlchemist whoAsked")
    XCTAssertEqual(msg.badgeInfo, ["predictions/Pompeyo"])
    XCTAssertEqual(msg.badges, ["predictions/blue-1", "premium/1"])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#FFF200")
    XCTAssertEqual(msg.displayName, "fladhi")
    XCTAssertEqual(msg.userLogin, "fladhi")
    XCTAssertEqual(msg.emotes, [])
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertEqual(msg.returningChatter, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "c96d75f7-6fe0-41d0-bd27-80643426613c")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "118220323")
    XCTAssertEqual(msg.tmiSentTs, 1_687_334_511_793)
    XCTAssertEqual(msg.clientNonce, "c5639d11fdac91cad488f52a0c0a927a")
    XCTAssertEqual(msg.userId, "686358047")
    XCTAssertTrue(
      try XCTUnwrap(msg.replyParent)
        == .init(
          displayName: "RoyaleAlchemist", userLogin: "royalealchemist",
          message:
            "Clash\\sRoyale\\sAPI\\sestá\\sde\\svuelta\\sPogChamp\\sPogChamp\\s.\\sSi\\shubo\\sun\\smantenimiento\\so\\suna\\sinterrupción\\sdel\\sservicio,\\sya\\sdebería\\shaber\\sterminado.\\sRoyale\\sAlchemist\\snecesitará\\sentre\\s5\\sy\\s1     0\\sminutos\\spara\\srecuperarse\\spor\\scompleto\\s|\\s@Pompeyo4",
          id: "0e772349-8bcd-42cb-9c91-1c9eece83af8", userId: "684111155")
    )
    XCTAssertTrue(
      try XCTUnwrap(msg.replyThreadParent)
        == .init(
          userLogin: "royalealchemist", messageId: "0e772349-8bcd-42cb-9c91-1c9eece83af8",
          displayName: "", userId: ""))
    XCTAssertNil(msg.pinnedChat)
    XCTAssertTrue(
      msg.parsingLeftOvers.isEmpty, "Non-empty parsing left-overs: \(msg.parsingLeftOvers)")
  }

  func testParsedValues10() throws {
    let string =
      #"@badge-info=;badges=rplace-2023/1;client-nonce=115b634f5401db203a9b2d920d51a2a1;color=#FF0000;display-name=SoyWasha;emotes=;first-msg=0;flags=;id=6cdf9fed-253e-4b16-9878-dd69719a867f;mod=0;reply-parent-display-name=PF_josegamer;reply-parent-msg-body=por\\sque\\sverayork??;reply-parent-msg-id=b6543543-798c-4260-a84e-5495af2b1c32;reply-parent-user-id=545021421;reply-parent-user-login=pf_josegamer;reply-thread-parent-display-name=PF_josegamer;reply-thread-parent-msg-id=b6543543-798c-4260-a84e-5495af2b1c32;reply-thread-parent-user-id=545021421;reply-thread-parent-user-login=pf_josegamer;returning-chatter=0;room-id=204708397;subscriber=0;tmi-sent-ts=1699075686188;turbo=0;user-id=708631959;user-type= :soywasha!soywasha@soywasha.tmi.twitch.tv PRIVMSG #yosoyricklive :@PF_josegamer es la mezcla de veracruz y nueva york xd"#

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "yosoyricklive")
    XCTAssertEqual(msg.message, "@PF_josegamer es la mezcla de veracruz y nueva york xd")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, ["rplace-2023/1"])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#FF0000")
    XCTAssertEqual(msg.displayName, "SoyWasha")
    XCTAssertEqual(msg.userLogin, "soywasha")
    XCTAssertEqual(msg.emotes, [])
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertEqual(msg.returningChatter, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "6cdf9fed-253e-4b16-9878-dd69719a867f")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "204708397")
    XCTAssertEqual(msg.tmiSentTs, 1_699_075_686_188)
    XCTAssertEqual(msg.clientNonce, "115b634f5401db203a9b2d920d51a2a1")
    XCTAssertEqual(msg.userId, "708631959")
    XCTAssertTrue(
      try XCTUnwrap(msg.replyParent)
        == .init(
          displayName: "PF_josegamer", userLogin: "pf_josegamer",
          message: "por\\\\sque\\\\sverayork??", id: "b6543543-798c-4260-a84e-5495af2b1c32",
          userId: "545021421"), "\(String(describing: msg.replyParent))"
    )
    XCTAssertTrue(
      try XCTUnwrap(msg.replyThreadParent)
        == .init(
          userLogin: "pf_josegamer", messageId: "b6543543-798c-4260-a84e-5495af2b1c32",
          displayName: "PF_josegamer", userId: "545021421"),
      "\(String(describing: msg.replyThreadParent))")
    XCTAssertNil(msg.pinnedChat)
    XCTAssertTrue(
      msg.parsingLeftOvers.isEmpty, "Non-empty parsing left-overs: \(msg.parsingLeftOvers)")
  }

  func testParsedValues11() throws {
    let string =
      #"@badge-info=;badges=rplace-2023/1;client-nonce=115b634f5401db203a9b2d920d51a2a1;color=#FF0000;display-name=SoyWasha;emotes=;first-msg=0;flags=;id=6cdf9fed-253e-4b16-9878-dd69719a867f;mod=0;reply-parent-display-name=PF_josegamer;reply-parent-msg-body=por\\sque\\sverayork??;reply-parent-msg-id=b6543543-798c-4260-a84e-5495af2b1c32;reply-parent-user-id=545021421;reply-parent-user-login=pf_josegamer;reply-thread-parent-display-name=PF_josegamer;reply-thread-parent-msg-id=b6543543-798c-4260-a84e-5495af2b1c32;reply-thread-parent-user-id=545021421;reply-thread-parent-user-login=pf_josegamer;returning-chatter=0;room-id=204708397;subscriber=0;tmi-sent-ts=1699075686188;turbo=0;user-id=708631959;user-type= :soywasha!soywasha@soywasha.tmi.twitch.tv PRIVMSG #yosoyricklive @PF_josegamer es la mezcla de veracruz y nueva york xd"#

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "yosoyricklive")
    XCTAssertEqual(msg.message, "@PF_josegamer es la mezcla de veracruz y nueva york xd")
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.badges, ["rplace-2023/1"])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#FF0000")
    XCTAssertEqual(msg.displayName, "SoyWasha")
    XCTAssertEqual(msg.userLogin, "soywasha")
    XCTAssertEqual(msg.emotes, [])
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertEqual(msg.returningChatter, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "6cdf9fed-253e-4b16-9878-dd69719a867f")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "204708397")
    XCTAssertEqual(msg.tmiSentTs, 1_699_075_686_188)
    XCTAssertEqual(msg.clientNonce, "115b634f5401db203a9b2d920d51a2a1")
    XCTAssertEqual(msg.userId, "708631959")
    XCTAssertTrue(
      try XCTUnwrap(msg.replyParent)
        == .init(
          displayName: "PF_josegamer", userLogin: "pf_josegamer",
          message: "por\\\\sque\\\\sverayork??", id: "b6543543-798c-4260-a84e-5495af2b1c32",
          userId: "545021421"), "\(String(describing: msg.replyParent))"
    )
    XCTAssertTrue(
      try XCTUnwrap(msg.replyThreadParent)
        == .init(
          userLogin: "pf_josegamer", messageId: "b6543543-798c-4260-a84e-5495af2b1c32",
          displayName: "PF_josegamer", userId: "545021421"),
      "\(String(describing: msg.replyThreadParent))")
    XCTAssertNil(msg.pinnedChat)
    XCTAssertTrue(
      msg.parsingLeftOvers.isEmpty, "Non-empty parsing left-overs: \(msg.parsingLeftOvers)")
  }
}
