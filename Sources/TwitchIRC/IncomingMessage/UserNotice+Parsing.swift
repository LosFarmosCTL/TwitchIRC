struct ParsedUserNotice {
  let messageId: UserNotice.MessageID
  let optionalKeyGroups: [[String]]
}

extension UserNotice.MessageID {
  static func parse(id: String?, parser: inout ParametersParser) -> ParsedUserNotice? {
    guard let id, let parse = payloadParsers[id] else { return nil }
    return parse(&parser)
  }

  private static let payloadParsers:
    [String: @Sendable (inout ParametersParser) -> ParsedUserNotice] = [
      "sub": { parser in
        ParsedUserNotice(
          messageId: .sub(.init(parser: &parser)),
          optionalKeyGroups: SubInfo.optionalKeyGroups)
      },
      "resub": { parser in
        ParsedUserNotice(
          messageId: .resub(.init(parser: &parser)),
          optionalKeyGroups: ReSubInfo.optionalKeyGroups)
      },
      "subgift": { parser in
        ParsedUserNotice(
          messageId: .subGift(.init(parser: &parser)),
          optionalKeyGroups: SubGiftInfo.optionalKeyGroups)
      },
      "anonsubgift": { parser in
        ParsedUserNotice(
          messageId: .anonSubGift(.init(parser: &parser)),
          optionalKeyGroups: SubGiftInfo.anonymousOptionalKeyGroups)
      },
      "submysterygift": { parser in
        ParsedUserNotice(
          messageId: .subMysteryGift(.init(parser: &parser)),
          optionalKeyGroups: SubMysteryGiftInfo.optionalKeyGroups)
      },
      "primepaidupgrade": { parser in
        ParsedUserNotice(
          messageId: .primePaidUpgrade(.init(parser: &parser)),
          optionalKeyGroups: PrimePaidUpgradeInfo.optionalKeyGroups)
      },
      "giftpaidupgrade": { parser in
        ParsedUserNotice(
          messageId: .giftPaidUpgrade(.init(parser: &parser)),
          optionalKeyGroups: GiftPaidUpgradeInfo.optionalKeyGroups)
      },
      "rewardgift": { _ in
        ParsedUserNotice(messageId: .rewardGift, optionalKeyGroups: [])
      },
      "anongiftpaidupgrade": { parser in
        ParsedUserNotice(
          messageId: .anonGiftPaidUpgrade(.init(parser: &parser)),
          optionalKeyGroups: AnonGiftPaidUpgradeInfo.optionalKeyGroups)
      },
      "raid": { parser in
        ParsedUserNotice(
          messageId: .raid(.init(parser: &parser)),
          optionalKeyGroups: RaidInfo.optionalKeyGroups)
      },
      "unraid": { _ in
        ParsedUserNotice(messageId: .unraid, optionalKeyGroups: [])
      },
      "ritual": { parser in
        ParsedUserNotice(
          messageId: .ritual(
            name: parser.string(for: "msg-param-ritual-name")
          ), optionalKeyGroups: [])
      },
      "bitsbadgetier": { parser in
        ParsedUserNotice(
          messageId: .bitsBadgeTier(
            threshold: parser.string(for: "msg-param-threshold")
          ), optionalKeyGroups: [])
      },
      "communitypayforward": { parser in
        ParsedUserNotice(
          messageId: .communityPayForward(.init(parser: &parser)),
          optionalKeyGroups: CommunityPayForwardInfo.optionalKeyGroups)
      },
      "standardpayforward": { parser in
        ParsedUserNotice(
          messageId: .standardPayForward(.init(parser: &parser)),
          optionalKeyGroups: StandardPayForwardInfo.optionalKeyGroups)
      },
      "announcement": { parser in
        ParsedUserNotice(
          messageId: .announcement(color: parser.optionalString(for: "msg-param-color")),
          optionalKeyGroups: [["msg-param-color"]])
      },
      "midnightsquid": { parser in
        ParsedUserNotice(
          messageId: .midnightSquid(.init(parser: &parser)),
          optionalKeyGroups: MidnightSquidInfo.optionalKeyGroups)
      },
      "charitydonation": { parser in
        ParsedUserNotice(
          messageId: .charityDonation(.init(parser: &parser)),
          optionalKeyGroups: CharityDonationInfo.optionalKeyGroups)
      },
      "modiversary": { parser in
        ParsedUserNotice(messageId: .modiversary(.init(parser: &parser)), optionalKeyGroups: [])
      },
      "viewermilestone": { parser in
        ParsedUserNotice(
          messageId: .viewerMilestone(.init(parser: &parser)),
          optionalKeyGroups: ViewerMilestoneInfo.optionalKeyGroups)
      },
    ]
}
