extension UserNotice.Kind {
  public struct PrimePaidUpgradeInfo: Sendable {
    /// IRC tag: `msg-param-sub-plan`.
    public private(set) var subPlan: SubPlan?

    public init(subPlan: SubPlan?) {
      self.subPlan = subPlan
    }

    internal init() {
      self.subPlan = nil
    }
    init(parser: inout ParametersParser) {
      self.init(
        subPlan: parser.representable(for: "msg-param-sub-plan")
      )
    }
  }

  public struct GiftPaidUpgradeInfo: Sendable {
    /// IRC tag: `msg-param-promo-gift-total`. Nil when absent.
    public private(set) var promoGiftTotal: UInt?
    /// IRC tag: `msg-param-promo-name`. Nil when absent.
    public private(set) var promoName: String?
    /// IRC tag: `msg-param-sender-login`.
    public private(set) var senderLogin: String
    /// IRC tag: `msg-param-sender-name`.
    public private(set) var senderName: String

    public init(
      promoGiftTotal: UInt? = nil,
      promoName: String? = nil,
      senderLogin: String,
      senderName: String
    ) {
      self.promoGiftTotal = promoGiftTotal
      self.promoName = promoName
      self.senderLogin = senderLogin
      self.senderName = senderName
    }

    internal init() {
      self.init(
        promoGiftTotal: nil,
        promoName: nil,
        senderLogin: String(),
        senderName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        promoGiftTotal: parser.optionalUInt(for: "msg-param-promo-gift-total"),
        promoName: parser.optionalString(for: "msg-param-promo-name"),
        senderLogin: parser.string(for: "msg-param-sender-login"),
        senderName: parser.string(for: "msg-param-sender-name")
      )
    }
  }

  public struct AnonGiftPaidUpgradeInfo: Sendable {
    /// IRC tag: `msg-param-promo-gift-total`. Nil when absent.
    public private(set) var promoGiftTotal: UInt?
    /// IRC tag: `msg-param-promo-name`. Nil when absent.
    public private(set) var promoName: String?

    public init(
      promoGiftTotal: UInt? = nil,
      promoName: String? = nil
    ) {
      self.promoGiftTotal = promoGiftTotal
      self.promoName = promoName
    }

    internal init() {
      self.init(
        promoGiftTotal: nil,
        promoName: nil
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        promoGiftTotal: parser.optionalUInt(for: "msg-param-promo-gift-total"),
        promoName: parser.optionalString(for: "msg-param-promo-name")
      )
    }
  }

}

extension UserNotice.Kind.PrimePaidUpgradeInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.Kind.GiftPaidUpgradeInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-promo-gift-total"],
    ["msg-param-promo-name"],
  ]
}

extension UserNotice.Kind.AnonGiftPaidUpgradeInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-promo-gift-total"],
    ["msg-param-promo-name"],
  ]
}
