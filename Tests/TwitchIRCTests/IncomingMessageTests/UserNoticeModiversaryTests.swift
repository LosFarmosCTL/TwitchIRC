import XCTest

@testable import TwitchIRC

final class UserNoticeModiversaryTests: XCTestCase {
  // Twitch's official USERNOTICE example, including its inconsistent system-message month count.
  private let officialExample =
    #"@badge-info=;badges=staff/1,moderator/1;color=#007EFE;display-name=BlueLava;emotes=;flags=;id=5d0a7492-b2c4-441b-be78-8606d16ec5e8;login=bluelava;mod=1;msg-id=modiversary;msg-param-months=108;room-id=141981764;subscriber=0;system-msg=has\sbeen\sa\smoderator\sfor\s24\smonths!;tmi-sent-ts=1780142048673;user-id=135093069;user-type=mod;vip=0 :tmi.twitch.tv USERNOTICE #twitchdev :I'm celebrating my 9 year Mod Anniversary!"#

  func testOfficialModiversaryExample() throws {
    let notice: UserNotice = try TestUtils.parseAndUnwrap(string: officialExample)
    guard case .modiversary(let info) = notice.messageId else {
      return XCTFail("Expected a Modiversary payload")
    }
    XCTAssertEqual(info.months, 108)
    XCTAssertEqual(notice.rawMessageId, "modiversary")
    XCTAssertEqual(notice.message, "I'm celebrating my 9 year Mod Anniversary!")
    XCTAssertEqual(notice.systemMessage, #"has\sbeen\sa\smoderator\sfor\s24\smonths!"#)
    XCTAssertEqual(notice.channel, "twitchdev")
    XCTAssertEqual(notice.userLogin, "bluelava")
    XCTAssertTrue(notice.isMod)
    XCTAssertTrue(notice.parsingLeftOvers.isEmpty, "\(notice.parsingLeftOvers)")
  }

  func testForwardedModiversaryWithoutUserMessage() throws {
    let message =
      officialExample
      .replacingOccurrences(
        of: "msg-id=modiversary;",
        with:
          "msg-id=sharedchatnotice;source-msg-id=modiversary;source-id=origin-id;source-room-id=141981764;source-badges=moderator/1;source-badge-info=;"
      )
      .replacingOccurrences(
        of: "#twitchdev :I'm celebrating my 9 year Mod Anniversary!", with: "#twitchrivals")
    let notice: UserNotice = try TestUtils.parseAndUnwrap(string: message)
    guard case .sharedChatNotice(let sourceNotice) = notice.messageId,
      case .modiversary(let info)? = sourceNotice
    else {
      return XCTFail("Expected a forwarded Modiversary payload")
    }
    XCTAssertEqual(info.months, 108)
    XCTAssertEqual(notice.message, "")
    XCTAssertEqual(notice.channel, "twitchrivals")
    XCTAssertEqual(notice.rawMessageId, "sharedchatnotice")
    XCTAssertEqual(notice.sourceMessageId, "modiversary")
    XCTAssertEqual(notice.source?.id, "origin-id")
    XCTAssertEqual(notice.source?.roomId, "141981764")
    XCTAssertTrue(notice.parsingLeftOvers.isEmpty, "\(notice.parsingLeftOvers)")
  }

  func testMissingOrMalformedMonthsRemainDiagnosable() throws {
    for replacement in ["", "msg-param-months=invalid;"] {
      let message = officialExample.replacingOccurrences(
        of: "msg-param-months=108;", with: replacement)
      let notice: UserNotice = try TestUtils.parseAndUnwrap(string: message)
      guard case .modiversary(let info) = notice.messageId else {
        return XCTFail("Expected a Modiversary payload")
      }
      XCTAssertEqual(info.months, 0)
      if replacement.isEmpty {
        XCTAssertEqual(notice.parsingLeftOvers.unavailableKeys, ["msg-param-months"])
        XCTAssertTrue(notice.parsingLeftOvers.unparsedKeys.isEmpty)
      } else {
        XCTAssertTrue(notice.parsingLeftOvers.unavailableKeys.isEmpty)
        XCTAssertEqual(notice.parsingLeftOvers.unparsedKeys.map(\.key), ["msg-param-months"])
        XCTAssertEqual(notice.parsingLeftOvers.unparsedKeys.map(\.value), ["invalid"])
      }
    }
  }
}
