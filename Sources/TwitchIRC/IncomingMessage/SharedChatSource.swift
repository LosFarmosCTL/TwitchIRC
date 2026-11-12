/// The originating message and channel of Shared Chat traffic.
/// The enclosing message's `id`, `roomID`, and `channel` still identify the receiving copy.
public struct SharedChatSource: MessageWithBadges {
  /// The source message's `source-id`, not its notice category.
  /// IRC tag: `source-id`.
  public private(set) var id: String?
  /// The source channel's Twitch identifier.
  /// IRC tag: `source-room-id`.
  public private(set) var roomID: String?
  /// Badge metadata in the source channel.
  /// IRC tag: `source-badge-info`.
  public private(set) var badgeInfo = [BadgeInfo]()
  /// The chatter's badges in the source channel.
  /// IRC tag: `source-badges`.
  public private(set) var badges = [Badge]()

  init?(parser: inout ParametersParser) {
    guard parser.contains(any: Self.tagKeys) else { return nil }
    self.id = parser.optionalNonEmptyString(for: "source-id")
    self.roomID = parser.optionalNonEmptyString(for: "source-room-id")
    self.badgeInfo = parser.badgeInfo(for: "source-badge-info")
    self.badges = parser.badges(for: "source-badges")
  }

  static let tagKeys = ["source-id", "source-room-id", "source-badge-info", "source-badges"]
  /// Creates a message from its required fields and optional metadata.
  public init(
    id: String?,
    roomID: String?,
    badgeInfo: [BadgeInfo] = [],
    badges: [Badge] = []
  ) {
    self.id = id
    self.roomID = roomID
    self.badgeInfo = badgeInfo
    self.badges = badges
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension SharedChatSource: Sendable {}
#endif
