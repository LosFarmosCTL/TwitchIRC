import XCTest

@testable import TwitchIRC

final class SharedChatTests: XCTestCase {

  /// Based on the originating message in Twitch's Shared Chat documentation.
  func testOriginatingChatMessage() throws {
    let string =
      "@badge-info=;badges=staff/1,twitchcon-2024---san-diego/1;color=#FF4500;display-name=TwitchDev;emotes=;first-msg=1;flags=;id=4dcec0e7-7f79-4a82-8aed-91aac9d0640c;returning-chatter=0;room-id=12826;source-badge-info=;source-badges=staff/1,twitchcon-2024---san-diego/1;source-id=4dcec0e7-7f79-4a82-8aed-91aac9d0640c;source-room-id=12826;tmi-sent-ts=1725918561648;user-id=141981764 :twitchdev!twitchdev@twitchdev.tmi.twitch.tv PRIVMSG #twitch :Howdy!"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "twitch")
    XCTAssertEqual(msg.message, "Howdy!")
    XCTAssertEqual(msg.source.id, msg.id)
    XCTAssertEqual(msg.source.roomId, msg.roomId)
    XCTAssertEqual(msg.source.badges, ["staff/1", "twitchcon-2024---san-diego/1"])
    XCTAssertEqual(msg.source.badgeInfo, [])
    XCTAssertTrue(msg.firstMessage)
    XCTAssertFalse(msg.returningChatter)
    XCTAssertFalse(msg.sourceOnly)
    XCTAssertTrue(msg.parsingLeftOvers.isEmpty, "\(msg.parsingLeftOvers)")
  }

  func testForwardedChatMessage() throws {
    let string =
      "@badge-info=;badges=staff/1;color=#FF4500;display-name=TwitchDev;emotes=;flags=;id=17152d83-1fc8-4869-9d44-5157ee212ff1;room-id=197886470;source-badge-info=subscriber/12;source-badges=staff/1,subscriber/12;source-id=4dcec0e7-7f79-4a82-8aed-91aac9d0640c;source-only=0;source-room-id=12826;tmi-sent-ts=1725918561648;user-id=141981764 :twitchdev!twitchdev@twitchdev.tmi.twitch.tv PRIVMSG #twitchrivals :Howdy!"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(msg.channel, "twitchrivals")
    XCTAssertEqual(msg.roomId, "197886470")
    XCTAssertEqual(msg.id, "17152d83-1fc8-4869-9d44-5157ee212ff1")
    XCTAssertEqual(msg.source.roomId, "12826")
    XCTAssertEqual(msg.source.id, "4dcec0e7-7f79-4a82-8aed-91aac9d0640c")
    XCTAssertEqual(msg.badges, ["staff/1"])
    XCTAssertEqual(msg.badgeInfo, [])
    XCTAssertEqual(msg.source.badges, ["staff/1", "subscriber/12"])
    XCTAssertEqual(msg.source.badgeInfo, ["subscriber/12"])
    XCTAssertTrue(msg.source.isSubscriber)
    XCTAssertFalse(msg.isSubscriber)
    XCTAssertEqual(msg.message, "Howdy!")
    XCTAssertEqual(msg.userLogin, "twitchdev")
    XCTAssertFalse(msg.sourceOnly)
    // Forwarded copies may omit these tags; retain the existing false defaults.
    XCTAssertFalse(msg.firstMessage)
    XCTAssertFalse(msg.returningChatter)
    XCTAssertEqual(msg.parsingLeftOvers.unavailableKeys, ["returning-chatter"])
    XCTAssertTrue(msg.parsingLeftOvers.unusedPairs.isEmpty)
    XCTAssertTrue(msg.parsingLeftOvers.unparsedKeys.isEmpty)
  }

  func testSourceOnlyChatMessage() throws {
    let string =
      "@badge-info=;badges=;color=;display-name=TwitchDev;emotes=;first-msg=0;id=source-chat;returning-chatter=0;room-id=12826;source-badge-info=;source-badges=;source-id=source-chat;source-only=1;source-room-id=12826;tmi-sent-ts=1725918561648;user-id=141981764 :twitchdev!twitchdev@twitchdev.tmi.twitch.tv PRIVMSG #twitch :Hello here"

    let msg: PrivateMessage = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertTrue(msg.sourceOnly)
    XCTAssertEqual(msg.source.id, msg.id)
    XCTAssertEqual(msg.source.roomId, msg.roomId)
    XCTAssertTrue(msg.parsingLeftOvers.isEmpty, "\(msg.parsingLeftOvers)")
  }

  func testSharedResubNotice() throws {
    let string =
      #"@badge-info=;badges=staff/1;color=#008000;display-name=ronni;emotes=;id=local-notice;login=ronni;msg-id=sharedchatnotice;msg-param-cumulative-months=6;msg-param-streak-months=2;msg-param-should-share-streak=1;msg-param-sub-plan=Prime;msg-param-sub-plan-name=Prime;room-id=197886470;source-badge-info=subscriber/6;source-badges=staff/1,subscriber/6;source-id=source-notice;source-msg-id=resub;source-room-id=12826;system-msg=ronni\shas\ssubscribed\sfor\s6\smonths!;tmi-sent-ts=1507246572675;user-id=1337;vip=0 :tmi.twitch.tv USERNOTICE #twitchrivals :Great stream -- keep it up!"#

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.channel, "twitchrivals")
    XCTAssertEqual(userNotice.roomId, "197886470")
    XCTAssertEqual(userNotice.id, "local-notice")
    XCTAssertEqual(userNotice.source.roomId, "12826")
    XCTAssertEqual(userNotice.source.id, "source-notice")
    XCTAssertEqual(userNotice.rawMessageId, "sharedchatnotice")
    XCTAssertEqual(userNotice.sourceMessageId, "resub")
    XCTAssertEqual(userNotice.badges, ["staff/1"])
    XCTAssertEqual(userNotice.badgeInfo, [])
    XCTAssertEqual(userNotice.source.badges, ["staff/1", "subscriber/6"])
    XCTAssertEqual(userNotice.source.badgeInfo, ["subscriber/6"])
    XCTAssertEqual(userNotice.message, "Great stream -- keep it up!")
    XCTAssertEqual(userNotice.systemMessage, #"ronni\shas\ssubscribed\sfor\s6\smonths!"#)
    XCTAssertEqual(userNotice.userLogin, "ronni")
    XCTAssertEqual(userNotice.userId, "1337")
    XCTAssertTrue(userNotice.parsingLeftOvers.isEmpty, "\(userNotice.parsingLeftOvers)")

    guard case .sharedChatNotice(let sourceNotice) = userNotice.messageId,
      case .resub(let info)? = sourceNotice
    else {
      return XCTFail("Expected a Shared Chat resub payload")
    }
    XCTAssertEqual(info.cumulativeMonths, 6)
    XCTAssertEqual(info.streakMonths, 2)
    XCTAssertTrue(info.shouldShareStreak)
    XCTAssertEqual(info.subPlan, .prime)
    XCTAssertEqual(info.subPlanName, "Prime")
  }

  func testSharedGiftNoticeWithoutUserMessage() throws {
    let string =
      "@badge-info=;badges=;color=;display-name=Gifter;emotes=;id=local-gift;login=gifter;msg-id=sharedchatnotice;msg-param-months=1;msg-param-recipient-display-name=Recipient;msg-param-recipient-id=42;msg-param-recipient-user-name=recipient;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1;room-id=197886470;source-badge-info=;source-badges=;source-id=source-gift;source-msg-id=subgift;source-room-id=12826;system-msg=Gift!;tmi-sent-ts=1507246572675;user-id=1337;vip=0 :tmi.twitch.tv USERNOTICE #twitchrivals"

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(userNotice.message, "")
    XCTAssertEqual(userNotice.sourceMessageId, "subgift")
    XCTAssertTrue(userNotice.parsingLeftOvers.isEmpty, "\(userNotice.parsingLeftOvers)")
    guard case .sharedChatNotice(let sourceNotice) = userNotice.messageId,
      case .subGift(let info)? = sourceNotice
    else {
      return XCTFail("Expected a Shared Chat gift payload")
    }
    XCTAssertEqual(info.months, 1)
    XCTAssertEqual(info.recipientDisplayName, "Recipient")
    XCTAssertEqual(info.recipientId, "42")
    XCTAssertEqual(info.recipientUserName, "recipient")
    XCTAssertEqual(info.subPlan, .tier1)
  }

  func testUnknownSourceNoticeCategory() throws {
    let string =
      "@badge-info=;badges=;color=;display-name=ronni;emotes=;id=local-unknown;login=ronni;msg-id=sharedchatnotice;msg-param-future=value;room-id=197886470;source-badge-info=subscriber/6;source-badges=subscriber/6;source-id=source-unknown;source-msg-id=future-notice;source-room-id=12826;system-msg=Future!;tmi-sent-ts=1507246572675;user-id=1337;vip=0 :tmi.twitch.tv USERNOTICE #twitchrivals :Still visible"

    let userNotice: UserNotice = try TestUtils.parseAndUnwrap(string: string)

    guard case .sharedChatNotice(let sourceNotice) = userNotice.messageId else {
      return XCTFail("Expected a Shared Chat notice")
    }
    XCTAssertNil(sourceNotice)
    XCTAssertEqual(userNotice.rawMessageId, "sharedchatnotice")
    XCTAssertEqual(userNotice.sourceMessageId, "future-notice")
    XCTAssertEqual(userNotice.channel, "twitchrivals")
    XCTAssertEqual(userNotice.roomId, "197886470")
    XCTAssertEqual(userNotice.id, "local-unknown")
    XCTAssertEqual(userNotice.source.roomId, "12826")
    XCTAssertEqual(userNotice.source.id, "source-unknown")
    XCTAssertEqual(userNotice.source.badges, ["subscriber/6"])
    XCTAssertEqual(userNotice.source.badgeInfo, ["subscriber/6"])
    XCTAssertEqual(userNotice.message, "Still visible")
    XCTAssertEqual(userNotice.systemMessage, "Future!")
    XCTAssertEqual(userNotice.userLogin, "ronni")
    XCTAssertTrue(userNotice.parsingLeftOvers.unavailableKeys.isEmpty)
    XCTAssertTrue(userNotice.parsingLeftOvers.unparsedKeys.isEmpty)
    XCTAssertEqual(userNotice.parsingLeftOvers.unusedPairs.map(\.key), ["msg-param-future"])
    XCTAssertEqual(userNotice.parsingLeftOvers.unusedPairs.map(\.value), ["value"])
  }
}
