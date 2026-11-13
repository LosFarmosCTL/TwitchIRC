import XCTest

@testable import TwitchIRC

final class UserNoticeUnknownTests: XCTestCase {
  func testUnknownCategoryPreservesEnvelopeAndTags() throws {
    for message in [nil, "Hello 👋"] as [String?] {
      let raw = makeNotice(category: "future-notice", message: message)
      let notice: UserNotice = try TestUtils.parseAndUnwrap(string: raw)
      guard case .unknown(let category) = notice.kind else {
        return XCTFail("Expected an unknown notice")
      }
      XCTAssertEqual(category, "future-notice")
      XCTAssertEqual(notice.rawKind, category)
      XCTAssertEqual(notice.channel, "channel")
      XCTAssertEqual(notice.message, message ?? "")
      XCTAssertEqual(notice.id, "notice-id")
      XCTAssertEqual(notice.roomID, "42")
      XCTAssertEqual(notice.userID, "123")
      XCTAssertEqual(notice.userLogin, "viewer")
      XCTAssertEqual(notice.displayName, "Viewer")
      XCTAssertEqual(notice.badges, [Badge(setID: "lead_moderator", version: "1")])
      XCTAssertTrue(notice.isMod)
      XCTAssertEqual(notice.systemMessage, "A future notice")
      XCTAssertEqual(notice.timestampMilliseconds, 1_780_142_048_673)
      XCTAssertEqual(
        notice.parsingLeftovers.unusedPairs.map(\.key), ["msg-param-future", "msg-param-empty"])
      XCTAssertEqual(notice.parsingLeftovers.unusedPairs.map(\.value), [#"some\svalue"#, ""])
      XCTAssertTrue(notice.parsingLeftovers.unavailableKeys.isEmpty)
      XCTAssertTrue(notice.parsingLeftovers.unparsedKeys.isEmpty)
      XCTAssertEqual(IncomingMessage.parse(ircOutput: raw).first?.text, raw)
    }
  }

  func testKnownCategoryAlsoPreservesRawIdentifier() throws {
    let notice: UserNotice = try TestUtils.parseAndUnwrap(
      string: makeNotice(category: "announcement"))
    guard case .announcement = notice.kind else {
      return XCTFail("Expected the existing announcement payload")
    }
    XCTAssertEqual(notice.rawKind, "announcement")
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
