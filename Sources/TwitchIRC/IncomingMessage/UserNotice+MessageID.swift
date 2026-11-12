extension UserNotice {
  public enum MessageID: Sendable {
    case sub(SubInfo)
    case resub(ReSubInfo)
    case subGift(SubGiftInfo)
    case anonSubGift(SubGiftInfo)
    case subMysteryGift(SubMysteryGiftInfo)
    case primePaidUpgrade(PrimePaidUpgradeInfo)
    case giftPaidUpgrade(GiftPaidUpgradeInfo)
    case rewardGift
    case anonGiftPaidUpgrade(AnonGiftPaidUpgradeInfo)
    case raid(RaidInfo)
    case unraid
    case ritual(name: String)
    case bitsBadgeTier(threshold: String)
    case communityPayForward(CommunityPayForwardInfo)
    case standardPayForward(StandardPayForwardInfo)
    case announcement(color: String?)
    case midnightSquid(MidnightSquidInfo)
    case charityDonation(CharityDonationInfo)
    case viewerMilestone(ViewerMilestoneInfo)
    /// A notice category not yet recognized by this library.
    /// Event-specific tags remain available in `UserNotice.parsingLeftOvers.unusedPairs`.
    case unknown(rawMessageId: String)
    /// A forwarded notice. The source payload is nil when the source notice type is unrecognized.
    indirect case sharedChatNotice(sourceNotice: MessageID?)
  }
}
