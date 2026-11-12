/// A Twitch `ROOMSTATE` message. Settings omitted from a partial update are `nil`.
public struct RoomState {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// Whether or not normal viewers can only send emotes.
  public private(set) var emoteOnly: Bool?
  /// Whether or not normal viewers need to be followers to chat.
  public private(set) var followersOnly: Int?
  /// Whether or not messages of normal viewers with more than 9 characters must be unique.
  public private(set) var r9k: Bool?
  /// Broadcaster's Twitch identifier.
  public private(set) var roomId = String()
  /// Number of seconds normal chatters need to wait between each sent message.
  public private(set) var slow: UInt?
  /// Whether or not normal viewers need to be a sub to chat.
  public private(set) var subsOnly: Bool?
  /// A flag for when you enter a channel and Twitch encourages you to send an emote.
  public private(set) var rituals = Bool()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard contentLhs.count > 2,
      contentRhs.first == "#"
    else { return nil }
    self.channel = String(contentRhs.dropFirst())

    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.emoteOnly = parser.optionalBool(for: "emote-only")
    self.followersOnly = parser.optionalInt(for: "followers-only")
    self.r9k = parser.optionalBool(for: "r9k")
    self.roomId = parser.string(for: "room-id")
    self.slow = parser.optionalUInt(for: "slow")
    self.subsOnly = parser.optionalBool(for: "subs-only")
    self.rituals = parser.bool(for: "rituals")

    let occasionalKeys = ["emote-only", "r9k", "slow", "subs-only", "rituals", "followers-only"]
    self.parsingLeftOvers = parser.getLeftOvers(
      excludedUnavailableKeys: occasionalKeys
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    emoteOnly: Bool? = nil,
    followersOnly: Int? = nil,
    r9k: Bool? = nil,
    roomId: String,
    slow: UInt? = nil,
    subsOnly: Bool? = nil,
    rituals: Bool = Bool(),
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.channel = channel
    self.emoteOnly = emoteOnly
    self.followersOnly = followersOnly
    self.r9k = r9k
    self.roomId = roomId
    self.slow = slow
    self.subsOnly = subsOnly
    self.rituals = rituals
    self.parsingLeftOvers = parsingLeftOvers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension RoomState: Sendable {}
#endif
