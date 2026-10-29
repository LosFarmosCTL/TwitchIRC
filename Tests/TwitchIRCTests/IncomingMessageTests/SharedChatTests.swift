@testable import TwitchIRC
import XCTest

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

        let un: UserNotice = try TestUtils.parseAndUnwrap(string: string)

        XCTAssertEqual(un.channel, "twitchrivals")
        XCTAssertEqual(un.roomId, "197886470")
        XCTAssertEqual(un.id, "local-notice")
        XCTAssertEqual(un.source.roomId, "12826")
        XCTAssertEqual(un.source.id, "source-notice")
        XCTAssertEqual(un.sourceMessageId, "resub")
        XCTAssertEqual(un.badges, ["staff/1"])
        XCTAssertEqual(un.badgeInfo, [])
        XCTAssertEqual(un.source.badges, ["staff/1", "subscriber/6"])
        XCTAssertEqual(un.source.badgeInfo, ["subscriber/6"])
        XCTAssertEqual(un.message, "Great stream -- keep it up!")
        XCTAssertEqual(un.systemMessage, #"ronni\shas\ssubscribed\sfor\s6\smonths!"#)
        XCTAssertEqual(un.userLogin, "ronni")
        XCTAssertEqual(un.userId, "1337")
        XCTAssertTrue(un.parsingLeftOvers.isEmpty, "\(un.parsingLeftOvers)")

        guard case let .sharedChatNotice(sourceNotice) = un.messageId,
              case let .resub(info)? = sourceNotice else {
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

        let un: UserNotice = try TestUtils.parseAndUnwrap(string: string)

        XCTAssertEqual(un.message, "")
        XCTAssertEqual(un.sourceMessageId, "subgift")
        XCTAssertTrue(un.parsingLeftOvers.isEmpty, "\(un.parsingLeftOvers)")
        guard case let .sharedChatNotice(sourceNotice) = un.messageId,
              case let .subGift(info)? = sourceNotice else {
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

        let un: UserNotice = try TestUtils.parseAndUnwrap(string: string)

        guard case let .sharedChatNotice(sourceNotice) = un.messageId else {
            return XCTFail("Expected a Shared Chat notice")
        }
        XCTAssertNil(sourceNotice)
        XCTAssertEqual(un.sourceMessageId, "future-notice")
        XCTAssertEqual(un.channel, "twitchrivals")
        XCTAssertEqual(un.roomId, "197886470")
        XCTAssertEqual(un.id, "local-unknown")
        XCTAssertEqual(un.source.roomId, "12826")
        XCTAssertEqual(un.source.id, "source-unknown")
        XCTAssertEqual(un.source.badges, ["subscriber/6"])
        XCTAssertEqual(un.source.badgeInfo, ["subscriber/6"])
        XCTAssertEqual(un.message, "Still visible")
        XCTAssertEqual(un.systemMessage, "Future!")
        XCTAssertEqual(un.userLogin, "ronni")
        XCTAssertTrue(un.parsingLeftOvers.unavailableKeys.isEmpty)
        XCTAssertTrue(un.parsingLeftOvers.unparsedKeys.isEmpty)
        XCTAssertEqual(un.parsingLeftOvers.unusedPairs.map(\.key), ["msg-param-future"])
        XCTAssertEqual(un.parsingLeftOvers.unusedPairs.map(\.value), ["value"])
    }
}
