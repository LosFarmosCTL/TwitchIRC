/// The originating message and channel of Shared Chat traffic.
/// The enclosing message's `id`, `roomId`, and `channel` still identify the receiving copy.
public struct SharedChatSource: MessageWithBadges {
  /// The source message's `source-id`, not its notice category.
  public private(set) var id: String?
  /// The source channel's Twitch identifier.
  public private(set) var roomId: String?
  /// Badge metadata in the source channel.
  public private(set) var badgeInfo = [String]()
  /// The chatter's badges in the source channel.
  public private(set) var badges = [String]()

  init?(parser: inout ParametersParser) {
    guard parser.contains(any: Self.tagKeys) else { return nil }
    self.id = parser.optionalNonEmptyString(for: "source-id")
    self.roomId = parser.optionalNonEmptyString(for: "source-room-id")
    self.badgeInfo = parser.array(for: "source-badge-info")
    self.badges = parser.array(for: "source-badges")
  }

  static let tagKeys = ["source-id", "source-room-id", "source-badge-info", "source-badges"]
  /// Creates a message from its required fields and optional metadata.
  public init(
    id: String?,
    roomId: String?,
    badgeInfo: [String] = [String](),
    badges: [String] = [String]()
  ) {
    self.id = id
    self.roomId = roomId
    self.badgeInfo = badgeInfo
    self.badges = badges
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension SharedChatSource: Sendable {}
#endif
