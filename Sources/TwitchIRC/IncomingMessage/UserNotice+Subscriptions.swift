extension UserNotice.MessageID {
  public enum SubPlan: String, Sendable {
    case followersTier = ""
    case tier1 = "1000"
    case tier2 = "2000"
    case tier3 = "3000"
    case prime = "Prime"
  }

  public struct SubInfo: Sendable {
    public private(set) var cumulativeMonths: UInt
    public private(set) var shouldShareStreak: Bool
    public private(set) var streakMonths: UInt
    public private(set) var subPlan: SubPlan?
    public private(set) var subPlanName: String
    public private(set) var months: UInt
    public private(set) var multimonthDuration: UInt
    public private(set) var multimonthTenure: Bool
    public private(set) var wasGifted: Bool
    public private(set) var goalContributionType: String
    public private(set) var goalCurrentContributions: String
    public private(set) var goalDescription: String
    public private(set) var goalTargetContributions: String
    public private(set) var goalUserContributions: String

    public init(
      cumulativeMonths: UInt,
      shouldShareStreak: Bool,
      streakMonths: UInt,
      subPlan: UserNotice.MessageID.SubPlan?,
      subPlanName: String,
      months: UInt,
      multimonthDuration: UInt,
      multimonthTenure: Bool,
      wasGifted: Bool,
      goalContributionType: String,
      goalCurrentContributions: String,
      goalDescription: String,
      goalTargetContributions: String,
      goalUserContributions: String
    ) {
      self.cumulativeMonths = cumulativeMonths
      self.shouldShareStreak = shouldShareStreak
      self.streakMonths = streakMonths
      self.subPlan = subPlan
      self.subPlanName = subPlanName
      self.months = months
      self.multimonthDuration = multimonthDuration
      self.multimonthTenure = multimonthTenure
      self.wasGifted = wasGifted
      self.goalContributionType = goalContributionType
      self.goalCurrentContributions = goalCurrentContributions
      self.goalDescription = goalDescription
      self.goalTargetContributions = goalTargetContributions
      self.goalUserContributions = goalUserContributions
    }

    internal init() {
      self.init(
        cumulativeMonths: UInt(),
        shouldShareStreak: Bool(),
        streakMonths: UInt(),
        subPlan: nil,
        subPlanName: String(),
        months: UInt(),
        multimonthDuration: UInt(),
        multimonthTenure: Bool(),
        wasGifted: Bool(),
        goalContributionType: String(),
        goalCurrentContributions: String(),
        goalDescription: String(),
        goalTargetContributions: String(),
        goalUserContributions: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        cumulativeMonths: parser.uint(for: "msg-param-cumulative-months"),
        shouldShareStreak: parser.bool(for: "msg-param-should-share-streak"),
        streakMonths: parser.uint(for: "msg-param-streak-months"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        subPlanName: parser.string(for: "msg-param-sub-plan-name"),
        months: parser.uint(for: "msg-param-months"),
        multimonthDuration: parser.uint(for: "msg-param-multimonth-duration"),
        multimonthTenure: parser.bool(for: "msg-param-multimonth-tenure"),
        wasGifted: parser.bool(for: "msg-param-was-gifted"),
        goalContributionType: parser.string(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.string(for: "msg-param-goal-current-contributions"),
        goalDescription: parser.string(for: "msg-param-goal-description"),
        goalTargetContributions: parser.string(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.string(for: "msg-param-goal-user-contributions")
      )
    }
  }

  public struct ReSubInfo: Sendable {
    public private(set) var cumulativeMonths: UInt
    public private(set) var shouldShareStreak: Bool
    public private(set) var streakMonths: UInt
    public private(set) var subPlan: SubPlan?
    public private(set) var subPlanName: String
    public private(set) var anonGift: Bool
    public private(set) var months: UInt
    public private(set) var multimonthDuration: UInt
    public private(set) var multimonthTenure: Bool
    public private(set) var wasGifted: Bool
    public private(set) var giftMonthBeingRedeemed: UInt
    public private(set) var giftMonths: UInt
    public private(set) var gifterId: String
    public private(set) var gifterLogin: String
    public private(set) var gifterName: String

    public init(
      cumulativeMonths: UInt,
      shouldShareStreak: Bool,
      streakMonths: UInt,
      subPlan: UserNotice.MessageID.SubPlan?,
      subPlanName: String,
      anonGift: Bool,
      months: UInt,
      multimonthDuration: UInt,
      multimonthTenure: Bool,
      wasGifted: Bool,
      giftMonthBeingRedeemed: UInt,
      giftMonths: UInt,
      gifterId: String,
      gifterLogin: String,
      gifterName: String
    ) {
      self.cumulativeMonths = cumulativeMonths
      self.shouldShareStreak = shouldShareStreak
      self.streakMonths = streakMonths
      self.subPlan = subPlan
      self.subPlanName = subPlanName
      self.anonGift = anonGift
      self.months = months
      self.multimonthDuration = multimonthDuration
      self.multimonthTenure = multimonthTenure
      self.wasGifted = wasGifted
      self.giftMonthBeingRedeemed = giftMonthBeingRedeemed
      self.giftMonths = giftMonths
      self.gifterId = gifterId
      self.gifterLogin = gifterLogin
      self.gifterName = gifterName
    }

    internal init() {
      self.init(
        cumulativeMonths: UInt(),
        shouldShareStreak: Bool(),
        streakMonths: UInt(),
        subPlan: nil,
        subPlanName: String(),
        anonGift: Bool(),
        months: UInt(),
        multimonthDuration: UInt(),
        multimonthTenure: Bool(),
        wasGifted: Bool(),
        giftMonthBeingRedeemed: UInt(),
        giftMonths: UInt(),
        gifterId: String(),
        gifterLogin: String(),
        gifterName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        cumulativeMonths: parser.uint(for: "msg-param-cumulative-months"),
        shouldShareStreak: parser.bool(for: "msg-param-should-share-streak"),
        streakMonths: parser.uint(for: "msg-param-streak-months"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        subPlanName: parser.string(for: "msg-param-sub-plan-name"),
        anonGift: parser.bool(for: "msg-param-anon-gift"),
        months: parser.uint(for: "msg-param-months"),
        multimonthDuration: parser.uint(for: "msg-param-multimonth-duration"),
        multimonthTenure: parser.bool(for: "msg-param-multimonth-tenure"),
        wasGifted: parser.bool(for: "msg-param-was-gifted"),
        giftMonthBeingRedeemed: parser.uint(for: "msg-param-gift-month-being-redeemed"),
        giftMonths: parser.uint(for: "msg-param-gift-months"),
        gifterId: parser.string(for: "msg-param-gifter-id"),
        gifterLogin: parser.string(for: "msg-param-gifter-login"),
        gifterName: parser.string(for: "msg-param-gifter-name")
      )
    }
  }

}

extension UserNotice.MessageID.SubInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-streak-months"], ["msg-param-goal-description"],
    [
      "msg-param-goal-contribution-type", "msg-param-goal-current-contributions",
      "msg-param-goal-description", "msg-param-goal-target-contributions",
      "msg-param-goal-user-contributions",
    ],
  ]
}

extension UserNotice.MessageID.ReSubInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-streak-months"],
    ["msg-param-multimonth-duration", "msg-param-multimonth-tenure"],
    [
      "msg-param-anon-gift", "msg-param-gift-month-being-redeemed", "msg-param-gift-months",
      "msg-param-gifter-id", "msg-param-gifter-login", "msg-param-gifter-name",
    ],
    [
      "msg-param-months", "msg-param-multimonth-duration", "msg-param-multimonth-tenure",
      "msg-param-was-gifted",
    ],
  ]
}
