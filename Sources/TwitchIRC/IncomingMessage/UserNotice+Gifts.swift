extension UserNotice.Kind {
  public struct SubGiftInfo: Sendable {
    /// IRC tag: `msg-param-months`.
    public private(set) var months: UInt
    /// IRC tag: `msg-param-recipient-display-name`.
    public private(set) var recipientDisplayName: String
    /// IRC tag: `msg-param-recipient-id`.
    public private(set) var recipientID: String
    /// IRC tag: `msg-param-recipient-user-name`.
    public private(set) var recipientUserName: String
    /// IRC tag: `msg-param-sub-plan`.
    public private(set) var subPlan: SubPlan?
    /// IRC tag: `msg-param-sub-plan-name`.
    public private(set) var subPlanName: String
    /// IRC tag: `msg-param-gift-months`.
    public private(set) var giftMonths: UInt
    /// IRC tag: `msg-param-origin-id`.
    public private(set) var originID: String
    /// IRC tag: `msg-param-sender-count`.
    public private(set) var senderCount: UInt
    /// IRC tag: `msg-param-fun-string`.
    public private(set) var funString: String
    /// IRC tag: `msg-param-gift-theme`.
    public private(set) var giftTheme: String
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
    /// IRC tag: `msg-param-community-gift-id`.
    public private(set) var communityGiftID: String

    public init(
      months: UInt,
      recipientDisplayName: String,
      recipientID: String,
      recipientUserName: String,
      subPlan: UserNotice.Kind.SubPlan?,
      subPlanName: String,
      giftMonths: UInt,
      originID: String,
      senderCount: UInt,
      funString: String,
      giftTheme: String,
      goalContributionType: String,
      goalCurrentContributions: String,
      goalDescription: String,
      goalTargetContributions: String,
      goalUserContributions: String,
      communityGiftID: String
    ) {
      self.months = months
      self.recipientDisplayName = recipientDisplayName
      self.recipientID = recipientID
      self.recipientUserName = recipientUserName
      self.subPlan = subPlan
      self.subPlanName = subPlanName
      self.giftMonths = giftMonths
      self.originID = originID
      self.senderCount = senderCount
      self.funString = funString
      self.giftTheme = giftTheme
      self.goalContributionType = goalContributionType
      self.goalCurrentContributions = goalCurrentContributions
      self.goalDescription = goalDescription
      self.goalTargetContributions = goalTargetContributions
      self.goalUserContributions = goalUserContributions
      self.communityGiftID = communityGiftID
    }

    internal init() {
      self.init(
        months: UInt(),
        recipientDisplayName: String(),
        recipientID: String(),
        recipientUserName: String(),
        subPlan: nil,
        subPlanName: String(),
        giftMonths: UInt(),
        originID: String(),
        senderCount: UInt(),
        funString: String(),
        giftTheme: String(),
        goalContributionType: String(),
        goalCurrentContributions: String(),
        goalDescription: String(),
        goalTargetContributions: String(),
        goalUserContributions: String(),
        communityGiftID: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        months: parser.uint(for: "msg-param-months"),
        recipientDisplayName: parser.string(for: "msg-param-recipient-display-name"),
        recipientID: parser.string(for: "msg-param-recipient-id"),
        recipientUserName: parser.string(for: "msg-param-recipient-user-name"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        subPlanName: parser.string(for: "msg-param-sub-plan-name"),
        giftMonths: parser.uint(for: "msg-param-gift-months"),
        originID: parser.string(for: "msg-param-origin-id"),
        senderCount: parser.uint(for: "msg-param-sender-count"),
        funString: parser.string(for: "msg-param-fun-string"),
        giftTheme: parser.string(for: "msg-param-gift-theme"),
        goalContributionType: parser.string(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.string(for: "msg-param-goal-current-contributions"),
        goalDescription: parser.string(for: "msg-param-goal-description"),
        goalTargetContributions: parser.string(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.string(for: "msg-param-goal-user-contributions"),
        communityGiftID: parser.string(for: "msg-param-community-gift-id")
      )
    }
  }

  public struct SubMysteryGiftInfo: Sendable {
    /// IRC tag: `msg-param-mass-gift-count`.
    public private(set) var massGiftCount: UInt
    /// IRC tag: `msg-param-origin-id`.
    public private(set) var originID: String
    /// IRC tag: `msg-param-sender-count`.
    public private(set) var senderCount: UInt
    /// IRC tag: `msg-param-sub-plan`.
    public private(set) var subPlan: SubPlan?
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
    /// IRC tag: `msg-param-gift-theme`.
    public private(set) var giftTheme: String
    /// IRC tag: `msg-param-community-gift-id`.
    public private(set) var communityGiftID: String

    public init(
      massGiftCount: UInt,
      originID: String,
      senderCount: UInt,
      subPlan: SubPlan?,
      goalContributionType: String,
      goalCurrentContributions: String,
      goalDescription: String,
      goalTargetContributions: String,
      goalUserContributions: String,
      giftTheme: String,
      communityGiftID: String
    ) {
      self.massGiftCount = massGiftCount
      self.originID = originID
      self.senderCount = senderCount
      self.subPlan = subPlan
      self.goalContributionType = goalContributionType
      self.goalCurrentContributions = goalCurrentContributions
      self.goalDescription = goalDescription
      self.goalTargetContributions = goalTargetContributions
      self.goalUserContributions = goalUserContributions
      self.giftTheme = giftTheme
      self.communityGiftID = communityGiftID
    }

    internal init() {
      self.init(
        massGiftCount: UInt(),
        originID: String(),
        senderCount: UInt(),
        subPlan: nil,
        goalContributionType: String(),
        goalCurrentContributions: String(),
        goalDescription: String(),
        goalTargetContributions: String(),
        goalUserContributions: String(),
        giftTheme: String(),
        communityGiftID: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        massGiftCount: parser.uint(for: "msg-param-mass-gift-count"),
        originID: parser.string(for: "msg-param-origin-id"),
        senderCount: parser.uint(for: "msg-param-sender-count"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        goalContributionType: parser.string(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.string(for: "msg-param-goal-current-contributions"),
        goalDescription: parser.string(for: "msg-param-goal-description"),
        goalTargetContributions: parser.string(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.string(for: "msg-param-goal-user-contributions"),
        giftTheme: parser.string(for: "msg-param-gift-theme"),
        communityGiftID: parser.string(for: "msg-param-community-gift-id")
      )
    }
  }

}

extension UserNotice.Kind.SubGiftInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-sender-count"], ["msg-param-goal-description"], ["msg-param-gift-theme"],
    ["msg-param-fun-string"], ["msg-param-gift-months", "msg-param-origin-id"],
    [
      "msg-param-goal-contribution-type", "msg-param-goal-current-contributions",
      "msg-param-goal-description", "msg-param-goal-target-contributions",
      "msg-param-goal-user-contributions",
    ], ["msg-param-community-gift-id"],
  ]
}

extension UserNotice.Kind.SubGiftInfo {
  static let anonymousOptionalKeyGroups: [[String]] = [
    ["msg-param-sender-count"], ["msg-param-fun-string"], ["msg-param-gift-theme"],
    ["msg-param-gift-months", "msg-param-origin-id"],
    [
      "msg-param-goal-contribution-type", "msg-param-goal-current-contributions",
      "msg-param-goal-description", "msg-param-goal-target-contributions",
      "msg-param-goal-user-contributions",
    ], ["msg-param-community-gift-id"],
  ]
}

extension UserNotice.Kind.SubMysteryGiftInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-goal-description"], ["msg-param-sender-count"],
    [
      "msg-param-goal-contribution-type", "msg-param-goal-current-contributions",
      "msg-param-goal-description", "msg-param-goal-target-contributions",
      "msg-param-goal-user-contributions",
    ], ["msg-param-gift-theme"],
  ]
}
