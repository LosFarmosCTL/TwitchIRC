import TwitchIRC
import XCTest

final class OptionalNoticeMetadataTests: XCTestCase {
  func testAnonGiftPaidUpgradeInfoWithoutConditionalMetadata() throws {
    let notice = try parse(kind: "anongiftpaidupgrade", tags: "")
    guard case .anonGiftPaidUpgrade(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.promoGiftTotal)
    XCTAssertNil(info.promoName)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testGiftPaidUpgradeInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "giftpaidupgrade", tags: "msg-param-sender-login=giver;msg-param-sender-name=Giver")
    guard case .giftPaidUpgrade(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.promoGiftTotal)
    XCTAssertNil(info.promoName)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testReSubInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "resub",
      tags: "msg-param-cumulative-months=1;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1")
    guard case .resub(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.shouldShareStreak)
    XCTAssertNil(info.streakMonths)
    XCTAssertNil(info.anonGift)
    XCTAssertNil(info.months)
    XCTAssertNil(info.multimonthDuration)
    XCTAssertNil(info.multimonthTenure)
    XCTAssertNil(info.wasGifted)
    XCTAssertNil(info.giftMonthBeingRedeemed)
    XCTAssertNil(info.giftMonths)
    XCTAssertNil(info.gifterID)
    XCTAssertNil(info.gifterLogin)
    XCTAssertNil(info.gifterName)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testSubInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "sub",
      tags: "msg-param-cumulative-months=1;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1")
    guard case .sub(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.shouldShareStreak)
    XCTAssertNil(info.streakMonths)
    XCTAssertNil(info.months)
    XCTAssertNil(info.multimonthDuration)
    XCTAssertNil(info.multimonthTenure)
    XCTAssertNil(info.wasGifted)
    XCTAssertNil(info.goalContributionType)
    XCTAssertNil(info.goalCurrentContributions)
    XCTAssertNil(info.goalDescription)
    XCTAssertNil(info.goalTargetContributions)
    XCTAssertNil(info.goalUserContributions)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testSubMysteryGiftInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "submysterygift", tags: "msg-param-mass-gift-count=5;msg-param-sub-plan=1000")
    guard case .subMysteryGift(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.originID)
    XCTAssertNil(info.senderCount)
    XCTAssertNil(info.giftTheme)
    XCTAssertNil(info.communityGiftID)
    XCTAssertNil(info.goalContributionType)
    XCTAssertNil(info.goalCurrentContributions)
    XCTAssertNil(info.goalDescription)
    XCTAssertNil(info.goalTargetContributions)
    XCTAssertNil(info.goalUserContributions)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testSubGiftInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "subgift",
      tags:
        "msg-param-months=1;msg-param-recipient-display-name=Recipient;msg-param-recipient-id=2;msg-param-recipient-user-name=recipient;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1"
    )
    guard case .subGift(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.giftMonths)
    XCTAssertNil(info.originID)
    XCTAssertNil(info.senderCount)
    XCTAssertNil(info.funString)
    XCTAssertNil(info.giftTheme)
    XCTAssertNil(info.communityGiftID)
    XCTAssertNil(info.goalContributionType)
    XCTAssertNil(info.goalCurrentContributions)
    XCTAssertNil(info.goalDescription)
    XCTAssertNil(info.goalTargetContributions)
    XCTAssertNil(info.goalUserContributions)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testStandardPayForwardInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "standardpayforward",
      tags:
        "msg-param-prior-gifter-anonymous=1;msg-param-recipient-display-name=Recipient;msg-param-recipient-id=2;msg-param-recipient-user-name=recipient"
    )
    guard case .standardPayForward(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.priorGifterDisplayName)
    XCTAssertNil(info.priorGifterID)
    XCTAssertNil(info.priorGifterUserName)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testCommunityPayForwardInfoWithoutConditionalMetadata() throws {
    let notice = try parse(kind: "communitypayforward", tags: "msg-param-prior-gifter-anonymous=1")
    guard case .communityPayForward(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.priorGifterDisplayName)
    XCTAssertNil(info.priorGifterID)
    XCTAssertNil(info.priorGifterUserName)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testRaidInfoWithoutConditionalMetadata() throws {
    let notice = try parse(
      kind: "raid",
      tags: "msg-param-displayName=Raider;msg-param-login=raider;msg-param-viewerCount=10")
    guard case .raid(let info) = notice.kind else {
      return XCTFail("Unexpected notice kind")
    }
    XCTAssertNil(info.profileImageURL)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testPresentZeroFalseAndEmptyTextAreNotAbsence() throws {
    let notice = try parse(
      kind: "resub",
      tags:
        "msg-param-cumulative-months=1;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1;msg-param-should-share-streak=0;msg-param-streak-months=0;msg-param-gift-months=0;msg-param-anon-gift=0;msg-param-gifter-login=;msg-param-gifter-id="
    )
    guard case .resub(let info) = notice.kind else { return XCTFail("Expected resub") }
    XCTAssertEqual(info.shouldShareStreak, false)
    XCTAssertEqual(info.streakMonths, 0)
    XCTAssertEqual(info.giftMonths, 0)
    XCTAssertEqual(info.anonGift, false)
    XCTAssertEqual(info.gifterLogin, "")
    XCTAssertNil(info.gifterID)
    XCTAssertNil(info.gifterName)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testInvalidOptionalValuesProduceNilAndDiagnostics() throws {
    let notice = try parse(
      kind: "resub",
      tags:
        "msg-param-cumulative-months=1;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1;msg-param-gift-months=invalid;msg-param-was-gifted=invalid"
    )
    guard case .resub(let info) = notice.kind else { return XCTFail("Expected resub") }
    XCTAssertNil(info.giftMonths)
    XCTAssertNil(info.wasGifted)
    XCTAssertEqual(
      notice.parsingLeftovers.unparsedKeys.map(\.key),
      ["msg-param-was-gifted", "msg-param-gift-months"])
    XCTAssertTrue(notice.parsingLeftovers.unavailableKeys.isEmpty)
  }

  func testPartialGoalMetadataAndExplicitEmptyTextSurvive() throws {
    let notice = try parse(
      kind: "sub",
      tags:
        "msg-param-cumulative-months=1;msg-param-sub-plan=1000;msg-param-sub-plan-name=Tier1;msg-param-goal-description="
    )
    guard case .sub(let info) = notice.kind else { return XCTFail("Expected sub") }
    XCTAssertEqual(info.goalDescription, "")
    XCTAssertNil(info.goalContributionType)
    XCTAssertTrue(notice.parsingLeftovers.isEmpty)
  }

  func testPublicConstructionCanOmitConditionalMetadata() {
    let sub = UserNotice.Kind.SubInfo(cumulativeMonths: 1, subPlan: .tier1, subPlanName: "Tier1")
    XCTAssertNil(sub.wasGifted)
    let resub = UserNotice.Kind.ReSubInfo(
      cumulativeMonths: 2, subPlan: .tier1, subPlanName: "Tier1")
    XCTAssertNil(resub.gifterID)
    let raid = UserNotice.Kind.RaidInfo(displayName: "Viewer", login: "viewer", viewerCount: 1)
    XCTAssertNil(raid.profileImageURL)
    let promo = UserNotice.Kind.AnonGiftPaidUpgradeInfo()
    XCTAssertNil(promo.promoGiftTotal)
    let milestone = UserNotice.Kind.ViewerMilestoneInfo(
      category: "watch-streak", id: "id", value: 3)
    XCTAssertNil(milestone.channelPointsReward)
  }

  private func parse(kind: String, tags: String) throws -> UserNotice {
    let line =
      "@badge-info=;badges=;color=;display-name=Viewer;emotes=;flags=;id=message;login=viewer;room-id=room;system-msg=;tmi-sent-ts=1000;user-id=user;msg-id="
      + kind + (tags.isEmpty ? "" : ";" + tags)
      + " :tmi.twitch.tv USERNOTICE #example :Hello"
    return try TestUtils.parseAndUnwrap(string: line)
  }
}
