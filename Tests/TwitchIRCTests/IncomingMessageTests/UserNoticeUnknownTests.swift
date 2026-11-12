import XCTest

@testable import TwitchIRC

final class UserNoticeUnknownTests: XCTestCase {
  func testUnknownCategoryPreservesEnvelopeAndTags() throws {
    for message in [nil, "Hello 👋"] as [String?] {
      let raw = makeNotice(category: "future-notice", message: message)
      let notice: UserNotice = try TestUtils.parseAndUnwrap(string: raw)
      guard case .unknown(let category) = notice.messageId else {
        return XCTFail("Expected an unknown notice")
      }
      XCTAssertEqual(category, "future-notice")
      XCTAssertEqual(notice.rawMessageId, category)
      XCTAssertEqual(notice.channel, "channel")
      XCTAssertEqual(notice.message, message ?? "")
      XCTAssertEqual(notice.id, "notice-id")
      XCTAssertEqual(notice.roomId, "42")
      XCTAssertEqual(notice.userId, "123")
      XCTAssertEqual(notice.userLogin, "viewer")
      XCTAssertEqual(notice.displayName, "Viewer")
      XCTAssertEqual(notice.badges, [Badge(setID: "lead_moderator", version: "1")])
      XCTAssertTrue(notice.isMod)
      XCTAssertEqual(notice.systemMessage, #"A\sfuture\snotice"#)
      XCTAssertEqual(notice.tmiSentTs, 1_780_142_048_673)
      XCTAssertEqual(
        notice.parsingLeftOvers.unusedPairs.map(\.key), ["msg-param-future", "msg-param-empty"])
      XCTAssertEqual(notice.parsingLeftOvers.unusedPairs.map(\.value), [#"some\svalue"#, ""])
      XCTAssertTrue(notice.parsingLeftOvers.unavailableKeys.isEmpty)
      XCTAssertTrue(notice.parsingLeftOvers.unparsedKeys.isEmpty)
      XCTAssertEqual(IncomingMessage.parse(ircOutput: raw).first?.text, raw)
    }
  }

  func testKnownCategoryAlsoPreservesRawIdentifier() throws {
    let notice: UserNotice = try TestUtils.parseAndUnwrap(
      string: makeNotice(category: "announcement"))
    guard case .announcement = notice.messageId else {
      return XCTFail("Expected the existing announcement payload")
    }
    XCTAssertEqual(notice.rawMessageId, "announcement")
  }

  func testMissingOrEmptyCategoryStillFailsParsing() {
    for category in [nil, ""] as [String?] {
      let raw = makeNotice(category: category)
      let result = IncomingMessage.parse(ircOutput: raw)
      XCTAssertEqual(result.count, 1)
      XCTAssertNil(result.first?.message)
      XCTAssertEqual(result.first?.text, raw)
    }
  }

  private func makeNotice(category: String?, message: String? = nil) -> String {
    let tags =
      #"@badge-info=;badges=lead_moderator/1;color=#007EFE;display-name=Viewer;emotes=;flags=;id=notice-id;login=viewer;room-id=42;system-msg=A\sfuture\snotice;tmi-sent-ts=1780142048673;user-id=123;vip=0;msg-param-future=some\svalue;msg-param-empty="#
    let categoryTag = category.map { ";msg-id=\($0)" } ?? ""
    let trailingMessage = message.map { " :\($0)" } ?? ""
    return "\(tags)\(categoryTag) :tmi.twitch.tv USERNOTICE #channel\(trailingMessage)"
  }
}
