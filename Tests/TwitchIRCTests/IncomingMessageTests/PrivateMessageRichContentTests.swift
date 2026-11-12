import XCTest

@testable import TwitchIRC

final class PrivateMessageRichContentTests: XCTestCase {

  func testParsedValues8() throws {
    let string =
      #"@badge-info=subscriber/8;badges=vip/1,subscriber/6,sub-gift-leader/1;color=#00FF7F;display-name=r3born_9999;emotes=;first-msg=0;flags=;id=011c7c65-6bab-4a9c-973e-2e04154e3877;mod=0;pinned-chat-paid-amount=100;pinned-chat-paid-canonical-amount=100;pinned-chat-paid-currency=USD;pinned-chat-paid-exponent=2;pinned-chat-paid-is-system-message=0;pinned-chat-paid-level=ONE;returning-chatter=0;room-id=123721524;subscriber=1;tmi-sent-ts=1687641306105;turbo=0;user-id=767491027;user-type=;vip=1 :r3born_9999!r3born_9999@r3born_9999.tmi.twitch.tv PRIVMSG #juicyjcr :will gift 5 subs as well if u clutch up"#

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "juicyjcr")
    XCTAssertEqual(msg.message, "will gift 5 subs as well if u clutch up")
    XCTAssertEqual(msg.badgeInfo, [BadgeInfo(setID: "subscriber", value: "8")])
    XCTAssertEqual(
      msg.badges,
      [
        Badge(setID: "vip", version: "1"), Badge(setID: "subscriber", version: "6"),
        Badge(setID: "sub-gift-leader", version: "1"),
      ])
    XCTAssertNil(msg.bits)
    XCTAssertEqual(msg.color, "#00FF7F")
    XCTAssertEqual(msg.displayName, "r3born_9999")
    XCTAssertEqual(msg.userLogin, "r3born_9999")
    XCTAssertEqual(msg.emotes, [])
    XCTAssertNil(msg.emoteOnly)
    XCTAssertEqual(msg.flags, [])
    XCTAssertEqual(msg.firstMessage, false)
    XCTAssertEqual(msg.returningChatter, false)
    XCTAssertNil(msg.messageId)
    XCTAssertEqual(msg.id, "011c7c65-6bab-4a9c-973e-2e04154e3877")
    XCTAssertNil(msg.crowdChantParentMessageId)
    XCTAssertNil(msg.customRewardId)
    XCTAssertEqual(msg.roomId, "123721524")
    XCTAssertEqual(msg.tmiSentTs, 1_687_641_306_105)
    XCTAssertNil(msg.clientNonce)
    XCTAssertEqual(msg.userId, "767491027")
    XCTAssertNil(msg.replyParent)
    XCTAssertTrue(
      try XCTUnwrap(msg.pinnedChat)
        == .init(
          amount: 100,
          canonicalAmount: 100,
          currency: "USD",
          exponent: 2,
          isSystemMessage: false,
          level: "ONE"
        ), "\(String(describing: msg.pinnedChat))")
    XCTAssertTrue(
      msg.parsingLeftOvers.isEmpty, "Non-empty parsing left-overs: \(msg.parsingLeftOvers)")
  }

  func testParsedValues12() throws {
    let string =
      #"@badge-info=subscriber/30;badges=broadcaster/1,subscriber/0;color=#033700;display-name=TwitchDev;emotes=;first-msg=0;flags=;gifs=0-33|joSNxeswxuc74Juo8X|https://media4.giphy.com/media/joSNxeswxuc74Juo8X/giphy.gif?cid=095d7a5dzizsiwgabonagkmigggv8v1spfai91ac3x0dsiy0&ep=v1_gifs_trending&rid=giphy.gif&ct=g;id=401abf17-7e99-45d6-9bdf-43934e839327;mod=0;returning-chatter=0;room-id=12826;subscriber=1;tmi-sent-ts=1783632907018;turbo=0;user-id=141981764;user-type= :twitchdev!twitchdev@twitchdev.tmi.twitch.tv PRIVMSG #twitch :[Y A Y Yes GIF by Djemilah Birnie]"#

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    let gifs = msg.gifs
    XCTAssertEqual(gifs.count, 1)
    let gif = try XCTUnwrap(gifs.first)
    XCTAssertEqual(gif.id, "joSNxeswxuc74Juo8X")
    XCTAssertEqual(
      gif.url,
      "https://media4.giphy.com/media/joSNxeswxuc74Juo8X/giphy.gif?cid=095d7a5dzizsiwgabonagkmigggv8v1spfai91ac3x0dsiy0&ep=v1_gifs_trending&rid=giphy.gif&ct=g"
    )
    XCTAssertEqual(gif.text, "[Y A Y Yes GIF by Djemilah Birnie]")
    XCTAssertEqual(gif.range.unicodeScalarOffsets.lowerBound, 0)
    XCTAssertEqual(gif.range.unicodeScalarOffsets.upperBound, 34)
    XCTAssertTrue(
      msg.parsingLeftOvers.isEmpty, "Non-empty parsing left-overs: \(msg.parsingLeftOvers)")
  }
}
