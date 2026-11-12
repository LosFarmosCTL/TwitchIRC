extension UserNotice.MessageID {
  public struct MidnightSquidInfo: Sendable {
    public private(set) var amount: UInt
    public private(set) var currency: String
    public private(set) var emoteId: String
    public private(set) var exponent: UInt
    public private(set) var isHighlighted: Bool
    public private(set) var pillType: String

    public init(
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

    internal init() {
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
    public private(set) var charityName: String
    public private(set) var amount: UInt
    public private(set) var currency: String
    public private(set) var exponent: UInt

    public init(
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

    internal init() {
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
    public private(set) var months = UInt()

    public init(months: UInt) {
      self.months = months
    }

    init(parser: inout ParametersParser) {
      self.months = parser.uint(for: "msg-param-months")
    }
  }

  public struct ViewerMilestoneInfo: Sendable {
    public private(set) var category: String
    public private(set) var id: String
    public private(set) var value: UInt
    /// Channel Points awarded for this milestone, when supplied.
    /// The `msg-param-copoReward` tag is unofficial and may be absent.
    public private(set) var copoReward: UInt?

    public init(
      category: String,
      id: String,
      value: UInt,
      copoReward: UInt?
    ) {
      self.category = category
      self.id = id
      self.value = value
      self.copoReward = copoReward
    }

    internal init() {
      self.init(
        category: String(),
        id: String(),
        value: UInt(),
        copoReward: nil
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        category: parser.string(for: "msg-param-category"),
        id: parser.string(for: "msg-param-id"),
        value: parser.uint(for: "msg-param-value"),
        copoReward: parser.optionalUInt(for: "msg-param-copoReward")
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
  static let optionalKeyGroups: [[String]] = [["msg-param-copoReward"]]
}
