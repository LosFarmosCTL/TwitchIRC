extension UserNotice.MessageID {
  public struct MidnightSquidInfo: Sendable {
    public var amount: UInt
    public var currency: String
    public var emoteId: String
    public var exponent: UInt
    public var isHighlighted: Bool
    public var pillType: String

    internal init(
      amount: UInt,
      currency: String,
      emoteId: String,
      exponent: UInt,
      isHighlighted: Bool,
      pillType: String
    ) {
      self.amount = amount
      self.currency = currency
      self.emoteId = emoteId
      self.exponent = exponent
      self.isHighlighted = isHighlighted
      self.pillType = pillType
    }

    public init() {
      self.init(
        amount: UInt(),
        currency: String(),
        emoteId: String(),
        exponent: UInt(),
        isHighlighted: Bool(),
        pillType: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        amount: parser.uint(for: "msg-param-amount"),
        currency: parser.string(for: "msg-param-currency"),
        emoteId: parser.string(for: "msg-param-emote-id"),
        exponent: parser.uint(for: "msg-param-exponent"),
        isHighlighted: parser.bool(for: "msg-param-is-highlighted"),
        pillType: parser.string(for: "msg-param-pill-type")
      )
    }
  }

  public struct CharityDonationInfo: Sendable {
    public var charityName: String
    public var amount: UInt
    public var currency: String
    public var exponent: UInt

    internal init(
      charityName: String,
      amount: UInt,
      currency: String,
      exponent: UInt
    ) {
      self.charityName = charityName
      self.amount = amount
      self.currency = currency
      self.exponent = exponent
    }

    public init() {
      self.init(
        charityName: String(),
        amount: UInt(),
        currency: String(),
        exponent: UInt()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        charityName: parser.string(for: "msg-param-charity-name"),
        amount: parser.uint(for: "msg-param-donation-amount"),
        currency: parser.string(for: "msg-param-donation-currency"),
        exponent: parser.uint(for: "msg-param-exponent")
      )
    }
  }

  public struct ModiversaryInfo: Sendable {
    /// Total number of months the user has been a moderator in this channel.
    public var months = UInt()

    public init() {}

    init(parser: inout ParametersParser) {
      self.months = parser.uint(for: "msg-param-months")
    }
  }

  public struct ViewerMilestoneInfo: Sendable {
    public var category: String
    public var id: String
    public var value: UInt
    public var copoReward: UInt

    internal init(
      category: String,
      id: String,
      value: UInt,
      copoReward: UInt
    ) {
      self.category = category
      self.id = id
      self.value = value
      self.copoReward = copoReward
    }

    public init() {
      self.init(
        category: String(),
        id: String(),
        value: UInt(),
        copoReward: UInt()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        category: parser.string(for: "msg-param-category"),
        id: parser.string(for: "msg-param-id"),
        value: parser.uint(for: "msg-param-value"),
        copoReward: parser.uint(for: "msg-param-copoReward")
      )
    }
  }

}

extension UserNotice.MessageID.MidnightSquidInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.MessageID.CharityDonationInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.MessageID.ViewerMilestoneInfo {
  static let optionalKeyGroups: [[String]] = []
}
