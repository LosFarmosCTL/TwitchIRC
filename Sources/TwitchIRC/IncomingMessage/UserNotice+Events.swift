extension UserNotice.Kind {
  public struct MidnightSquidInfo: Sendable {
    /// IRC tag: `msg-param-amount`.
    public private(set) var amount: UInt
    /// IRC tag: `msg-param-currency`.
    public private(set) var currency: String
    /// IRC tag: `msg-param-emote-id`.
    public private(set) var emoteID: String
    /// IRC tag: `msg-param-exponent`.
    public private(set) var exponent: UInt
    /// IRC tag: `msg-param-is-highlighted`.
    public private(set) var isHighlighted: Bool
    /// IRC tag: `msg-param-pill-type`.
    public private(set) var pillType: String

    public init(
      amount: UInt,
      currency: String,
      emoteID: String,
      exponent: UInt,
      isHighlighted: Bool,
      pillType: String
    ) {
      self.amount = amount
      self.currency = currency
      self.emoteID = emoteID
      self.exponent = exponent
      self.isHighlighted = isHighlighted
      self.pillType = pillType
    }

    internal init() {
      self.init(
        amount: UInt(),
        currency: String(),
        emoteID: String(),
        exponent: UInt(),
        isHighlighted: Bool(),
        pillType: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        amount: parser.uint(for: "msg-param-amount"),
        currency: parser.string(for: "msg-param-currency"),
        emoteID: parser.string(for: "msg-param-emote-id"),
        exponent: parser.uint(for: "msg-param-exponent"),
        isHighlighted: parser.bool(for: "msg-param-is-highlighted"),
        pillType: parser.string(for: "msg-param-pill-type")
      )
    }
  }

  public struct CharityDonationInfo: Sendable {
    /// IRC tag: `msg-param-charity-name`.
    public private(set) var charityName: String
    /// IRC tag: `msg-param-donation-amount`.
    public private(set) var amount: UInt
    /// IRC tag: `msg-param-donation-currency`.
    public private(set) var currency: String
    /// IRC tag: `msg-param-exponent`.
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
    /// IRC tag: `msg-param-months`.
    public private(set) var months = UInt()

    public init(months: UInt) {
      self.months = months
    }

    init(parser: inout ParametersParser) {
      self.months = parser.uint(for: "msg-param-months")
    }
  }

  public struct ViewerMilestoneInfo: Sendable {
    /// IRC tag: `msg-param-category`.
    public private(set) var category: String
    /// IRC tag: `msg-param-id`.
    public private(set) var id: String
    /// IRC tag: `msg-param-value`.
    public private(set) var value: UInt
    /// Channel Points awarded for this milestone, when supplied.
    /// IRC tag: `msg-param-copoReward`. Unofficial; may be absent.
    public private(set) var channelPointsReward: UInt?

    public init(
      category: String,
      id: String,
      value: UInt,
      channelPointsReward: UInt? = nil
    ) {
      self.category = category
      self.id = id
      self.value = value
      self.channelPointsReward = channelPointsReward
    }

    internal init() {
      self.init(
        category: String(),
        id: String(),
        value: UInt(),
        channelPointsReward: nil
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        category: parser.string(for: "msg-param-category"),
        id: parser.string(for: "msg-param-id"),
        value: parser.uint(for: "msg-param-value"),
        channelPointsReward: parser.optionalUInt(for: "msg-param-copoReward")
      )
    }
  }

}

extension UserNotice.Kind.MidnightSquidInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.Kind.CharityDonationInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.Kind.ViewerMilestoneInfo {
  static let optionalKeyGroups: [[String]] = [["msg-param-copoReward"]]
}
