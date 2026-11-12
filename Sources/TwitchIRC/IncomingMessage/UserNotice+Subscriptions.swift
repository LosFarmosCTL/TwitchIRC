extension UserNotice.Kind {
  public enum SubPlan: String, Sendable {
    case followersTier = ""
    case tier1 = "1000"
    case tier2 = "2000"
    case tier3 = "3000"
    case prime = "Prime"
  }

  public struct SubInfo: Sendable {
    /// IRC tag: `msg-param-cumulative-months`.
    public private(set) var cumulativeMonths: UInt
    /// IRC tag: `msg-param-should-share-streak`.
    public private(set) var shouldShareStreak: Bool
    /// IRC tag: `msg-param-streak-months`.
    public private(set) var streakMonths: UInt
    /// IRC tag: `msg-param-sub-plan`.
    public private(set) var subPlan: SubPlan?
    /// IRC tag: `msg-param-sub-plan-name`.
    public private(set) var subPlanName: String
    /// IRC tag: `msg-param-months`.
    public private(set) var months: UInt
    /// IRC tag: `msg-param-multimonth-duration`.
    public private(set) var multimonthDuration: UInt
    /// IRC tag: `msg-param-multimonth-tenure`.
    public private(set) var multimonthTenure: Bool
    /// IRC tag: `msg-param-was-gifted`.
    public private(set) var wasGifted: Bool
    /// IRC tag: `msg-param-goal-contribution-type`.
    public private(set) var goalContributionType: String
    /// IRC tag: `msg-param-goal-current-contributions`.
    public private(set) var goalCurrentContributions: String
    /// IRC tag: `msg-param-goal-description`.
    public private(set) var goalDescription: String
    /// IRC tag: `msg-param-goal-target-contributions`.
    public private(set) var goalTargetContributions: String
    /// IRC tag: `msg-param-goal-user-contributions`.
    public private(set) var goalUserContributions: String

    public init(
      cumulativeMonths: UInt,
      shouldShareStreak: Bool,
      streakMonths: UInt,
      subPlan: UserNotice.Kind.SubPlan?,
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
    /// IRC tag: `msg-param-cumulative-months`.
    public private(set) var cumulativeMonths: UInt
    /// IRC tag: `msg-param-should-share-streak`.
    public private(set) var shouldShareStreak: Bool
    /// IRC tag: `msg-param-streak-months`.
    public private(set) var streakMonths: UInt
    /// IRC tag: `msg-param-sub-plan`.
    public private(set) var subPlan: SubPlan?
    /// IRC tag: `msg-param-sub-plan-name`.
    public private(set) var subPlanName: String
    /// IRC tag: `msg-param-anon-gift`.
    public private(set) var anonGift: Bool
    /// IRC tag: `msg-param-months`.
    public private(set) var months: UInt
    /// IRC tag: `msg-param-multimonth-duration`.
    public private(set) var multimonthDuration: UInt
    /// IRC tag: `msg-param-multimonth-tenure`.
    public private(set) var multimonthTenure: Bool
    /// IRC tag: `msg-param-was-gifted`.
    public private(set) var wasGifted: Bool
    /// IRC tag: `msg-param-gift-month-being-redeemed`.
    public private(set) var giftMonthBeingRedeemed: UInt
    /// IRC tag: `msg-param-gift-months`.
    public private(set) var giftMonths: UInt
    /// IRC tag: `msg-param-gifter-id`.
    public private(set) var gifterID: String
    /// IRC tag: `msg-param-gifter-login`.
    public private(set) var gifterLogin: String
    /// IRC tag: `msg-param-gifter-name`.
    public private(set) var gifterName: String

    public init(
      cumulativeMonths: UInt,
      shouldShareStreak: Bool,
      streakMonths: UInt,
      subPlan: UserNotice.Kind.SubPlan?,
      subPlanName: String,
      anonGift: Bool,
      months: UInt,
      multimonthDuration: UInt,
      multimonthTenure: Bool,
      wasGifted: Bool,
      giftMonthBeingRedeemed: UInt,
      giftMonths: UInt,
      gifterID: String,
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
      self.gifterID = gifterID
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
        gifterID: String(),
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
        gifterID: parser.string(for: "msg-param-gifter-id"),
        gifterLogin: parser.string(for: "msg-param-gifter-login"),
        gifterName: parser.string(for: "msg-param-gifter-name")
      )
    }
  }

}

extension UserNotice.Kind.SubInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-streak-months"], ["msg-param-goal-description"],
    [
      "msg-param-goal-contribution-type", "msg-param-goal-current-contributions",
      "msg-param-goal-description", "msg-param-goal-target-contributions",
      "msg-param-goal-user-contributions",
    ],
  ]
}

extension UserNotice.Kind.ReSubInfo {
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
