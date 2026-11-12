extension UserNotice.MessageID {
  public struct PrimePaidUpgradeInfo: Sendable {
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
    public private(set) var promoGiftTotal: UInt
    public private(set) var promoName: String
    public private(set) var senderLogin: String
    public private(set) var senderName: String

    public init(
      promoGiftTotal: UInt,
      promoName: String,
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
        promoGiftTotal: UInt(),
        promoName: String(),
        senderLogin: String(),
        senderName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        promoGiftTotal: parser.uint(for: "msg-param-promo-gift-total"),
        promoName: parser.string(for: "msg-param-promo-name"),
        senderLogin: parser.string(for: "msg-param-sender-login"),
        senderName: parser.string(for: "msg-param-sender-name")
      )
    }
  }

  public struct AnonGiftPaidUpgradeInfo: Sendable {
    public private(set) var promoGiftTotal: UInt
    public private(set) var promoName: String

    public init(
      promoGiftTotal: UInt,
      promoName: String
    ) {
      self.promoGiftTotal = promoGiftTotal
      self.promoName = promoName
    }

    internal init() {
      self.init(
        promoGiftTotal: UInt(),
        promoName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        promoGiftTotal: parser.uint(for: "msg-param-promo-gift-total"),
        promoName: parser.string(for: "msg-param-promo-name")
      )
    }
  }

}

extension UserNotice.MessageID.PrimePaidUpgradeInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.MessageID.GiftPaidUpgradeInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-promo-gift-total", "msg-param-promo-name"]
  ]
}

extension UserNotice.MessageID.AnonGiftPaidUpgradeInfo {
  static let optionalKeyGroups: [[String]] = [
    ["msg-param-promo-gift-total"], ["msg-param-promo-name"],
  ]
}
