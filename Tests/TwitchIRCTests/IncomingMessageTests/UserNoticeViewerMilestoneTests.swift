import XCTest

@testable import TwitchIRC

final class UserNoticeViewerMilestoneTests: XCTestCase {
  // Twitch's official Watch Streak example omits the unofficial reward and VIP tags.
  private let officialExample =
    #"@badge-info=;badges=;color=#1E90FF;display-name=TwitchDev;emotes=;flags=;id=97459ff9-8cd9-47d0-8a81-1fa5fe1d4367;login=twitchdev;mod=0;msg-id=viewermilestone;msg-param-category=watch-streak;msg-param-id=a872953b-606f-410a-9970-c95b744f116c;msg-param-value=3;room-id=197886470;subscriber=0;system-msg=TwitchDev\swatched\s3\sconsecutive\sstreams\sthis\smonth\sand\ssparked\sa\swatch\sstreak!;tmi-sent-ts=1681057151588;user-id=141981764;user-type= :tmi.twitch.tv USERNOTICE #twitchrivals"#

  func testOfficialExampleWithoutUnofficialTags() throws {
    let notice: UserNotice = try TestUtils.parseAndUnwrap(string: officialExample)
    guard case .viewerMilestone(let info) = notice.messageId else {
      return XCTFail("Expected a viewer milestone payload")
    }
    XCTAssertEqual(info.category, "watch-streak")
    XCTAssertEqual(info.id, "a872953b-606f-410a-9970-c95b744f116c")
    XCTAssertEqual(info.value, 3)
    XCTAssertNil(info.copoReward)
    XCTAssertNil(notice.vip)
    XCTAssertTrue(notice.parsingLeftOvers.isEmpty, "\(notice.parsingLeftOvers)")
  }

  func testExplicitRewardsAndVIPValuesArePreserved() throws {
    for (reward, vip) in [(UInt(0), false), (UInt(450), true)] {
      let message = addingTags("msg-param-copoReward=\(reward);vip=\(vip ? 1 : 0)")
      let notice: UserNotice = try TestUtils.parseAndUnwrap(string: message)
      guard case .viewerMilestone(let info) = notice.messageId else {
        return XCTFail("Expected a viewer milestone payload")
      }
      XCTAssertEqual(info.copoReward, reward)
      XCTAssertEqual(notice.vip, vip)
      XCTAssertTrue(notice.parsingLeftOvers.isEmpty, "\(notice.parsingLeftOvers)")
    }
  }

  func testMalformedOptionalValuesStillProduceDiagnostics() throws {
    for tag in ["msg-param-copoReward=invalid", "vip=invalid"] {
      let notice: UserNotice = try TestUtils.parseAndUnwrap(string: addingTags(tag))
      guard case .viewerMilestone(let info) = notice.messageId else {
        return XCTFail("Expected a viewer milestone payload")
      }
      XCTAssertNil(info.copoReward)
      XCTAssertNil(notice.vip)
      XCTAssertTrue(notice.parsingLeftOvers.unavailableKeys.isEmpty)
      XCTAssertTrue(notice.parsingLeftOvers.unusedPairs.isEmpty)
      XCTAssertEqual(
        notice.parsingLeftOvers.unparsedKeys.map(\.key), [String(tag.prefix { $0 != "=" })])
      XCTAssertEqual(notice.parsingLeftOvers.unparsedKeys.map(\.value), ["invalid"])
    }
  }

  private func addingTags(_ tags: String) -> String {
    officialExample.replacingOccurrences(of: " :tmi.twitch.tv", with: ";\(tags) :tmi.twitch.tv")
  }
}
