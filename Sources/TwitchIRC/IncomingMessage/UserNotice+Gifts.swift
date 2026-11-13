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
    /// IRC tag: `msg-param-gift-months`. Nil when absent.
    public private(set) var giftMonths: UInt?
    /// IRC tag: `msg-param-origin-id`. Nil when absent.
    public private(set) var originID: String?
    /// IRC tag: `msg-param-sender-count`. Nil when absent.
    public private(set) var senderCount: UInt?
    /// IRC tag: `msg-param-fun-string`. Nil when absent.
    public private(set) var funString: String?
    /// IRC tag: `msg-param-gift-theme`. Nil when absent.
    public private(set) var giftTheme: String?
    /// IRC tag: `msg-param-goal-contribution-type`. Nil when absent.
    public private(set) var goalContributionType: String?
    /// IRC tag: `msg-param-goal-current-contributions`. Nil when absent.
    public private(set) var goalCurrentContributions: String?
    /// IRC tag: `msg-param-goal-description`. Nil when absent.
    public private(set) var goalDescription: String?
    /// IRC tag: `msg-param-goal-target-contributions`. Nil when absent.
    public private(set) var goalTargetContributions: String?
    /// IRC tag: `msg-param-goal-user-contributions`. Nil when absent.
    public private(set) var goalUserContributions: String?
    /// IRC tag: `msg-param-community-gift-id`. Nil when absent.
    public private(set) var communityGiftID: String?

    public init(
      months: UInt,
      recipientDisplayName: String,
      recipientID: String,
      recipientUserName: String,
      subPlan: UserNotice.Kind.SubPlan?,
      subPlanName: String,
      giftMonths: UInt? = nil,
      originID: String? = nil,
      senderCount: UInt? = nil,
      funString: String? = nil,
      giftTheme: String? = nil,
      goalContributionType: String? = nil,
      goalCurrentContributions: String? = nil,
      goalDescription: String? = nil,
      goalTargetContributions: String? = nil,
      goalUserContributions: String? = nil,
      communityGiftID: String? = nil
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
        giftMonths: nil,
        originID: nil,
        senderCount: nil,
        funString: nil,
        giftTheme: nil,
        goalContributionType: nil,
        goalCurrentContributions: nil,
        goalDescription: nil,
        goalTargetContributions: nil,
        goalUserContributions: nil,
        communityGiftID: nil
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
        giftMonths: parser.optionalUInt(for: "msg-param-gift-months"),
        originID: parser.optionalNonEmptyString(for: "msg-param-origin-id"),
        senderCount: parser.optionalUInt(for: "msg-param-sender-count"),
        funString: parser.optionalString(for: "msg-param-fun-string"),
        giftTheme: parser.optionalString(for: "msg-param-gift-theme"),
        goalContributionType: parser.optionalString(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.optionalString(
          for: "msg-param-goal-current-contributions"),
        goalDescription: parser.optionalString(for: "msg-param-goal-description"),
        goalTargetContributions: parser.optionalString(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.optionalString(for: "msg-param-goal-user-contributions"),
        communityGiftID: parser.optionalNonEmptyString(for: "msg-param-community-gift-id")
      )
    }
  }

  public struct SubMysteryGiftInfo: Sendable {
    /// IRC tag: `msg-param-mass-gift-count`.
    public private(set) var massGiftCount: UInt
    /// IRC tag: `msg-param-origin-id`. Nil when absent.
    public private(set) var originID: String?
    /// IRC tag: `msg-param-sender-count`. Nil when absent.
    public private(set) var senderCount: UInt?
    /// IRC tag: `msg-param-sub-plan`.
    public private(set) var subPlan: SubPlan?
    /// IRC tag: `msg-param-goal-contribution-type`. Nil when absent.
    public private(set) var goalContributionType: String?
    /// IRC tag: `msg-param-goal-current-contributions`. Nil when absent.
    public private(set) var goalCurrentContributions: String?
    /// IRC tag: `msg-param-goal-description`. Nil when absent.
    public private(set) var goalDescription: String?
    /// IRC tag: `msg-param-goal-target-contributions`. Nil when absent.
    public private(set) var goalTargetContributions: String?
    /// IRC tag: `msg-param-goal-user-contributions`. Nil when absent.
    public private(set) var goalUserContributions: String?
    /// IRC tag: `msg-param-gift-theme`. Nil when absent.
    public private(set) var giftTheme: String?
    /// IRC tag: `msg-param-community-gift-id`. Nil when absent.
    public private(set) var communityGiftID: String?

    public init(
      massGiftCount: UInt,
      originID: String? = nil,
      senderCount: UInt? = nil,
      subPlan: SubPlan?,
      goalContributionType: String? = nil,
      goalCurrentContributions: String? = nil,
      goalDescription: String? = nil,
      goalTargetContributions: String? = nil,
      goalUserContributions: String? = nil,
      giftTheme: String? = nil,
      communityGiftID: String? = nil
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
        originID: nil,
        senderCount: nil,
        subPlan: nil,
        goalContributionType: nil,
        goalCurrentContributions: nil,
        goalDescription: nil,
        goalTargetContributions: nil,
        goalUserContributions: nil,
        giftTheme: nil,
        communityGiftID: nil
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        massGiftCount: parser.uint(for: "msg-param-mass-gift-count"),
        originID: parser.optionalNonEmptyString(for: "msg-param-origin-id"),
        senderCount: parser.optionalUInt(for: "msg-param-sender-count"),
        subPlan: parser.representable(for: "msg-param-sub-plan"),
        goalContributionType: parser.optionalString(for: "msg-param-goal-contribution-type"),
        goalCurrentContributions: parser.optionalString(
          for: "msg-param-goal-current-contributions"),
        goalDescription: parser.optionalString(for: "msg-param-goal-description"),
        goalTargetContributions: parser.optionalString(for: "msg-param-goal-target-contributions"),
        goalUserContributions: parser.optionalString(for: "msg-param-goal-user-contributions"),
        giftTheme: parser.optionalString(for: "msg-param-gift-theme"),
        communityGiftID: parser.optionalNonEmptyString(for: "msg-param-community-gift-id")
      )
    }
  }

}

extension UserNotice.Kind.SubGiftInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-gift-months"],
    ["msg-param-origin-id"],
    ["msg-param-sender-count"],
    ["msg-param-fun-string"],
    ["msg-param-gift-theme"],
    ["msg-param-community-gift-id"],
    ["msg-param-goal-contribution-type"],
    ["msg-param-goal-current-contributions"],
    ["msg-param-goal-description"],
    ["msg-param-goal-target-contributions"],
    ["msg-param-goal-user-contributions"],
  ]
  static let anonymousOptionalKeyGroups = optionalKeyGroups
}

extension UserNotice.Kind.SubMysteryGiftInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-origin-id"],
    ["msg-param-sender-count"],
    ["msg-param-gift-theme"],
    ["msg-param-community-gift-id"],
    ["msg-param-goal-contribution-type"],
    ["msg-param-goal-current-contributions"],
    ["msg-param-goal-description"],
    ["msg-param-goal-target-contributions"],
    ["msg-param-goal-user-contributions"],
  ]
}
