import TwitchIRC
import XCTest

final class NoticeTargetTests: XCTestCase {
  func testKnownAndUnknownNoticesRetainTargets() throws {
    for code in ["whisper_restricted", "future_notice"] {
      let line =
        "@msg-id=" + code
        + ";target-user-id=123 :tmi.twitch.tv NOTICE #example :Restricted"
      let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
      guard case .notice(let notice) = result.message else {
        return XCTFail("Expected a notice")
      }
      XCTAssertEqual(notice.targetUserID, "123")
      XCTAssertEqual(notice.rawCode, code)
      XCTAssertTrue(notice.parsingLeftovers.isEmpty)
      XCTAssertEqual(result.rawMessage?.tags.last?.name, "target-user-id")
      XCTAssertEqual(result.rawMessage?.tags.last?.value, "123")
    }
  }

  func testAbsentAndEmptyTargetsAreNil() throws {
    for tag in ["", ";target-user-id="] {
      let notice: Notice = try TestUtils.parseAndUnwrap(
        string: "@msg-id=whisper_restricted" + tag
          + " :tmi.twitch.tv NOTICE #example :Restricted")
      XCTAssertNil(notice.targetUserID)
      XCTAssertTrue(notice.parsingLeftovers.isEmpty)
    }
  }

  func testTaggedGlobalNoticesRetainTargets() throws {
    let notice: Notice = try TestUtils.parseAndUnwrap(
      string: "@target-user-id=123 :tmi.twitch.tv NOTICE * :Restricted")
    guard case .global(let message) = notice.kind else {
      return XCTFail("Expected a global notice")
    }
    XCTAssertEqual(message, "Restricted")
    XCTAssertEqual(notice.targetUserID, "123")
    XCTAssertNil(notice.rawCode)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testPublicConstructionWithTarget() {
    let notice = Notice(
      kind: .local(channel: "example", message: "Restricted", code: .whisperRestricted),
      targetUserID: "123")
    XCTAssertEqual(notice.targetUserID, "123")
    XCTAssertNil(Notice(kind: .global(message: "Connected")).targetUserID)
  }
}
