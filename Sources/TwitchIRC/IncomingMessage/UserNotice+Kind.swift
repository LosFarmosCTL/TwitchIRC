extension UserNotice {
  /// A typed notice category decoded from the IRC `msg-id` tag.
  public enum Kind: Sendable {
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
    /// A moderator sharing their anniversary in the channel.
    case modiversary(ModiversaryInfo)
    case viewerMilestone(ViewerMilestoneInfo)
    /// A notice category not yet recognized by this library.
    /// Event-specific tags remain available in `UserNotice.parsingLeftovers.unusedPairs`.
    case unknown(rawKind: String)
    /// A forwarded notice. The source payload is nil when the source notice type is unrecognized.
    indirect case sharedChatNotice(sourceNotice: Kind?)
  }
}
