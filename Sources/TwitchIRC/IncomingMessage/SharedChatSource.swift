
/// The originating message and channel of Shared Chat traffic.
/// The enclosing message's `id`, `roomId`, and `channel` still identify the receiving copy.
public struct SharedChatSource: MessageWithBadges {
    /// The source message's `source-id`, not its notice category.
    public var id = String()
    /// The source channel's Twitch identifier.
    public var roomId = String()
    /// Badge metadata in the source channel.
    public var badgeInfo = [String]()
    /// The chatter's badges in the source channel.
    public var badges = [String]()

    public init() { }

    init(parser: inout ParametersParser) {
        self.id = parser.string(for: "source-id")
        self.roomId = parser.string(for: "source-room-id")
        self.badgeInfo = parser.array(for: "source-badge-info")
        self.badges = parser.array(for: "source-badges")
    }

    static let tagKeys = ["source-id", "source-room-id", "source-badge-info", "source-badges"]
}

// MARK: - Sendable conformance
#if swift(>=5.5)
extension SharedChatSource: Sendable { }
#endif
