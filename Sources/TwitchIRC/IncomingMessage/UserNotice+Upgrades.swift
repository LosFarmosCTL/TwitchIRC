extension UserNotice.MessageID {
  public struct PrimePaidUpgradeInfo: Sendable {
    public var subPlan: SubPlan?

    internal init(subPlan: SubPlan?) {
      self.subPlan = subPlan
    }

    public init() {
      self.subPlan = nil
    }
    init(parser: inout ParametersParser) {
      self.init(
        subPlan: parser.representable(for: "msg-param-sub-plan")
      )
    }
  }

  public struct GiftPaidUpgradeInfo: Sendable {
    public var promoGiftTotal: UInt
    public var promoName: String
    public var senderLogin: String
    public var senderName: String

    internal init(
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

    public init() {
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
    public var promoGiftTotal: UInt
    public var promoName: String

    internal init(
      promoGiftTotal: UInt,
      promoName: String
    ) {
      self.promoGiftTotal = promoGiftTotal
      self.promoName = promoName
    }

    public init() {
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
