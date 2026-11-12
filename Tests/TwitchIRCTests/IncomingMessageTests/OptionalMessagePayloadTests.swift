import XCTest

@testable import TwitchIRC

final class OptionalMessagePayloadTests: XCTestCase {
  func testAbsentFeaturesAreNil() throws {
    let message = try parseMessage()
    XCTAssertNil(message.replyParent)
    XCTAssertNil(message.replyThreadParent)
    XCTAssertNil(message.pinnedChat)
    XCTAssertNil(message.source)
    XCTAssertNil(message.firstMessage)
    XCTAssertNil(message.returningChatter)
    XCTAssertNil(message.sourceOnly)
    XCTAssertNil(message.timestampMilliseconds)
    XCTAssertNil(message.color)
    XCTAssertNil(message.bits)
    XCTAssertNil(message.clientNonce)
    XCTAssertTrue(message.parsingLeftovers.isEmpty, "\(message.parsingLeftovers)")
  }

  func testExplicitFalseAndZeroAreNotAbsent() throws {
    let message = try parseMessage(
      tags: "first-msg=0;returning-chatter=0;emote-only=0;source-only=0;tmi-sent-ts=0;bits=0")
    XCTAssertEqual(message.firstMessage, false)
    XCTAssertEqual(message.returningChatter, false)
    XCTAssertEqual(message.emoteOnly, false)
    XCTAssertEqual(message.sourceOnly, false)
    XCTAssertEqual(message.timestampMilliseconds, 0)
    XCTAssertEqual(message.bits, "0")
    XCTAssertNil(message.source)
    XCTAssertTrue(message.parsingLeftovers.isEmpty, "\(message.parsingLeftovers)")
  }

  func testPartialPayloadsPreserveAvailableFields() throws {
    let message = try parseMessage(
      tags:
        "reply-parent-msg-id=parent;reply-thread-parent-msg-id=thread;pinned-chat-paid-amount=0;source-badges=lead_moderator/1"
    )
    let reply = try XCTUnwrap(message.replyParent)
    XCTAssertEqual(reply.id, "parent")
    XCTAssertNil(reply.userID)
    XCTAssertNil(reply.displayName)
    let thread = try XCTUnwrap(message.replyThreadParent)
    XCTAssertEqual(thread.messageID, "thread")
    XCTAssertNil(thread.userLogin)
    let pinned = try XCTUnwrap(message.pinnedChat)
    XCTAssertEqual(pinned.amount, 0)
    XCTAssertNil(pinned.currency)
    XCTAssertNil(pinned.isSystemMessage)
    let source = try XCTUnwrap(message.source)
    XCTAssertNil(source.id)
    XCTAssertNil(source.roomID)
    XCTAssertTrue(source.isMod)
    XCTAssertTrue(message.parsingLeftovers.unavailableKeys.contains("source-id"))
  }

  func testMalformedPayloadValueIsNotConvertedToZero() throws {
    let message = try parseMessage(tags: "pinned-chat-paid-amount=invalid")
    let pinned = try XCTUnwrap(message.pinnedChat)
    XCTAssertNil(pinned.amount)
    XCTAssertEqual(message.parsingLeftovers.unparsedKeys.map(\.key), ["pinned-chat-paid-amount"])
  }

  private func parseMessage(tags: String = "") throws -> PrivateMessage {
    let common =
      "@badge-info=;badges=;color=;display-name=Viewer;emotes=;flags=;id=message;room-id=room;user-id=user"
    let extra = tags.isEmpty ? "" : ";\(tags)"
    return try TestUtils.parseAndUnwrap(
      string: "\(common)\(extra) :viewer!viewer@viewer.tmi.twitch.tv PRIVMSG #channel :Hello")
  }
}
