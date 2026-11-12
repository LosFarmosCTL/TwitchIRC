struct ParsedUserNotice {
  let kind: UserNotice.Kind
  let optionalKeyGroups: [[String]]
}

extension UserNotice.Kind {
  static func parse(id: String?, parser: inout ParametersParser) -> ParsedUserNotice? {
    guard let id, let parse = payloadParsers[id] else { return nil }
    return parse(&parser)
  }

  private static let payloadParsers:
    [String: @Sendable (inout ParametersParser) -> ParsedUserNotice] = [
      "sub": { parser in
        ParsedUserNotice(
          kind: .sub(.init(parser: &parser)),
          optionalKeyGroups: SubInfo.optionalKeyGroups)
      },
      "resub": { parser in
        ParsedUserNotice(
          kind: .resub(.init(parser: &parser)),
          optionalKeyGroups: ReSubInfo.optionalKeyGroups)
      },
      "subgift": { parser in
        ParsedUserNotice(
          kind: .subGift(.init(parser: &parser)),
          optionalKeyGroups: SubGiftInfo.optionalKeyGroups)
      },
      "anonsubgift": { parser in
        ParsedUserNotice(
          kind: .anonSubGift(.init(parser: &parser)),
          optionalKeyGroups: SubGiftInfo.anonymousOptionalKeyGroups)
      },
      "submysterygift": { parser in
        ParsedUserNotice(
          kind: .subMysteryGift(.init(parser: &parser)),
          optionalKeyGroups: SubMysteryGiftInfo.optionalKeyGroups)
      },
      "primepaidupgrade": { parser in
        ParsedUserNotice(
          kind: .primePaidUpgrade(.init(parser: &parser)),
          optionalKeyGroups: PrimePaidUpgradeInfo.optionalKeyGroups)
      },
      "giftpaidupgrade": { parser in
        ParsedUserNotice(
          kind: .giftPaidUpgrade(.init(parser: &parser)),
          optionalKeyGroups: GiftPaidUpgradeInfo.optionalKeyGroups)
      },
      "rewardgift": { _ in
        ParsedUserNotice(kind: .rewardGift, optionalKeyGroups: [])
      },
      "anongiftpaidupgrade": { parser in
        ParsedUserNotice(
          kind: .anonGiftPaidUpgrade(.init(parser: &parser)),
          optionalKeyGroups: AnonGiftPaidUpgradeInfo.optionalKeyGroups)
      },
      "raid": { parser in
        ParsedUserNotice(
          kind: .raid(.init(parser: &parser)),
          optionalKeyGroups: RaidInfo.optionalKeyGroups)
      },
      "unraid": { _ in
        ParsedUserNotice(kind: .unraid, optionalKeyGroups: [])
      },
      "ritual": { parser in
        ParsedUserNotice(
          kind: .ritual(
            name: parser.string(for: "msg-param-ritual-name")
          ), optionalKeyGroups: [])
      },
      "bitsbadgetier": { parser in
        ParsedUserNotice(
          kind: .bitsBadgeTier(
            threshold: parser.string(for: "msg-param-threshold")
          ), optionalKeyGroups: [])
      },
      "communitypayforward": { parser in
        ParsedUserNotice(
          kind: .communityPayForward(.init(parser: &parser)),
          optionalKeyGroups: CommunityPayForwardInfo.optionalKeyGroups)
      },
      "standardpayforward": { parser in
        ParsedUserNotice(
          kind: .standardPayForward(.init(parser: &parser)),
          optionalKeyGroups: StandardPayForwardInfo.optionalKeyGroups)
      },
      "announcement": { parser in
        ParsedUserNotice(
          kind: .announcement(color: parser.optionalString(for: "msg-param-color")),
          optionalKeyGroups: [["msg-param-color"]])
      },
      "midnightsquid": { parser in
        ParsedUserNotice(
          kind: .midnightSquid(.init(parser: &parser)),
          optionalKeyGroups: MidnightSquidInfo.optionalKeyGroups)
      },
      "charitydonation": { parser in
        ParsedUserNotice(
          kind: .charityDonation(.init(parser: &parser)),
          optionalKeyGroups: CharityDonationInfo.optionalKeyGroups)
      },
      "modiversary": { parser in
        ParsedUserNotice(kind: .modiversary(.init(parser: &parser)), optionalKeyGroups: [])
      },
      "viewermilestone": { parser in
        ParsedUserNotice(
          kind: .viewerMilestone(.init(parser: &parser)),
          optionalKeyGroups: ViewerMilestoneInfo.optionalKeyGroups)
      },
    ]
}
