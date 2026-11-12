extension UserNotice.MessageID {
  public struct SubGiftInfo: Sendable {
    public private(set) var months: UInt
    public private(set) var recipientDisplayName: String
    public private(set) var recipientId: String
    public private(set) var recipientUserName: String
    public private(set) var subPlan: SubPlan?
    public private(set) var subPlanName: String
    public private(set) var giftMonths: UInt
    public private(set) var originId: String
    public private(set) var senderCount: UInt
    public private(set) var funString: String
    public private(set) var giftTheme: String
    public private(set) var goalContributionType: String
    public private(set) var goalCurrentContributions: String
    public private(set) var goalDescription: String
    public private(set) var goalTargetContributions: String
    public private(set) var goalUserContributions: String
    public private(set) var communityGiftId: String

    public init(
      months: UInt,
      recipientDisplayName: String,
      recipientId: String,
      recipientUserName: String,
      subPlan: UserNotice.MessageID.SubPlan?,
      subPlanName: String,
      giftMonths: UInt,
      originId: String,
      senderCount: UInt,
      funString: String,
      giftTheme: String,
      goalContributionType: String,
      goalCurrentContributions: String,
      goalDescription: String,
      goalTargetContributions: String,
      goalUserContributions: String,
      communityGiftId: String
    ) {
      self.months = months
      self.recipientDisplayName = recipientDisplayName
      self.recipientId = recipientId
      self.recipientUserName = recipientUserName
      self.subPlan = subPlan
      self.subPlanName = subPlanName
      self.giftMonths = giftMonths
      self.originId = originId
      self.senderCount = senderCount
      self.funString = funString
      self.giftTheme = giftTheme
      self.goalContributionType = goalContributionType
      self.goalCurrentContributions = goalCurrentContributions
      self.goalDescription = goalDescription
      self.goalTargetContributions = goalTargetContributions
      self.goalUserContributions = goalUserContributions
      self.communityGiftId = communityGiftId
    }

    internal init() {
      self.init(
        months: UInt(),
        recipientDisplayName: String(),
        recipientId: String(),
        recipientUserName: String(),
        subPlan: nil,
        subPlanName: String(),
        giftMonths: UInt(),
        originId: String(),
        senderCount: UInt(),
        funString: String(),
        giftTheme: String(),
        goalContributionType: String(),
        goalCurrentContributions: String(),
        goalDescription: String(),
        goalTargetContributions: String(),
        goalUserContributions: String(),
        communityGiftId: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        months: parser.uint(for: "msg-param-months"),
        recipientDisplayName: parser.string(for: "msg-param-recipient-display-name"),
        recipientId: parser.string(for: "msg-param-recipient-id"),
        recipientUserName: parser.string(for: "msg-param-recipient-user-name"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        subPlanName: parser.string(for: "msg-param-sub-plan-name"),
        giftMonths: parser.uint(for: "msg-param-gift-months"),
        originId: parser.string(for: "msg-param-origin-id"),
        senderCount: parser.uint(for: "msg-param-sender-count"),
        funString: parser.string(for: "msg-param-fun-string"),
        giftTheme: parser.string(for: "msg-param-gift-theme"),
        goalContributionType: parser.string(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.string(for: "msg-param-goal-current-contributions"),
        goalDescription: parser.string(for: "msg-param-goal-description"),
        goalTargetContributions: parser.string(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.string(for: "msg-param-goal-user-contributions"),
        communityGiftId: parser.string(for: "msg-param-community-gift-id")
      )
    }
  }

  public struct SubMysteryGiftInfo: Sendable {
    public private(set) var massGiftCount: UInt
    public private(set) var originId: String
    public private(set) var senderCount: UInt
    public private(set) var subPlan: SubPlan?
    public private(set) var goalContributionType: String
    public private(set) var goalCurrentContributions: String
    public private(set) var goalDescription: String
    public private(set) var goalTargetContributions: String
    public private(set) var goalUserContributions: String
    public private(set) var giftTheme: String
    public private(set) var communityGiftId: String

    public init(
      massGiftCount: UInt,
      originId: String,
      senderCount: UInt,
      subPlan: SubPlan?,
      goalContributionType: String,
      goalCurrentContributions: String,
      goalDescription: String,
      goalTargetContributions: String,
      goalUserContributions: String,
      giftTheme: String,
      communityGiftId: String
    ) {
      self.massGiftCount = massGiftCount
      self.originId = originId
      self.senderCount = senderCount
      self.subPlan = subPlan
      self.goalContributionType = goalContributionType
      self.goalCurrentContributions = goalCurrentContributions
      self.goalDescription = goalDescription
      self.goalTargetContributions = goalTargetContributions
      self.goalUserContributions = goalUserContributions
      self.giftTheme = giftTheme
      self.communityGiftId = communityGiftId
    }

    internal init() {
      self.init(
        massGiftCount: UInt(),
        originId: String(),
        senderCount: UInt(),
        subPlan: nil,
        goalContributionType: String(),
        goalCurrentContributions: String(),
        goalDescription: String(),
        goalTargetContributions: String(),
        goalUserContributions: String(),
        giftTheme: String(),
        communityGiftId: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        massGiftCount: parser.uint(for: "msg-param-mass-gift-count"),
        originId: parser.string(for: "msg-param-origin-id"),
        senderCount: parser.uint(for: "msg-param-sender-count"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        goalContributionType: parser.string(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.string(for: "msg-param-goal-current-contributions"),
        goalDescription: parser.string(for: "msg-param-goal-description"),
        goalTargetContributions: parser.string(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.string(for: "msg-param-goal-user-contributions"),
        giftTheme: parser.string(for: "msg-param-gift-theme"),
        communityGiftId: parser.string(for: "msg-param-community-gift-id")
      )
    }
  }

}

extension UserNotice.MessageID.SubGiftInfo {
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

extension UserNotice.MessageID.SubGiftInfo {
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

extension UserNotice.MessageID.SubMysteryGiftInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-goal-description"], ["msg-param-sender-count"],
    [
      "msg-param-goal-contribution-type", "msg-param-goal-current-contributions",
      "msg-param-goal-description", "msg-param-goal-target-contributions",
      "msg-param-goal-user-contributions",
    ], ["msg-param-gift-theme"],
  ]
}
