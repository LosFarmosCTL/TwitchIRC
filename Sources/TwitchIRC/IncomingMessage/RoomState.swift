/// A Twitch `ROOMSTATE` message. Settings omitted from a partial update are `nil`.
public struct RoomState {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// Whether or not normal viewers can only send emotes.
  /// IRC tag: `emote-only`.
  public private(set) var emoteOnly: Bool?
  /// Whether or not normal viewers need to be followers to chat.
  /// IRC tag: `followers-only`.
  public private(set) var followersOnly: Int?
  /// Whether or not messages of normal viewers with more than 9 characters must be unique.
  /// IRC tag: `r9k`.
  public private(set) var r9k: Bool?
  /// Broadcaster's Twitch identifier.
  /// IRC tag: `room-id`.
  public private(set) var roomID = String()
  /// Number of seconds normal chatters need to wait between each sent message.
  /// IRC tag: `slow`.
  public private(set) var slow: UInt?
  /// Whether or not normal viewers need to be a sub to chat.
  /// IRC tag: `subs-only`.
  public private(set) var subsOnly: Bool?
  /// A flag for when you enter a channel and Twitch encourages you to send an emote.
  /// IRC tag: `rituals`.
  public private(set) var rituals: Bool?
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

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
    self.roomID = parser.string(for: "room-id")
    self.slow = parser.optionalUInt(for: "slow")
    self.subsOnly = parser.optionalBool(for: "subs-only")
    self.rituals = parser.optionalBool(for: "rituals")

    let occasionalKeys = ["emote-only", "r9k", "slow", "subs-only", "rituals", "followers-only"]
    self.parsingLeftovers = parser.getLeftOvers(
      excludedUnavailableKeys: occasionalKeys
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    emoteOnly: Bool? = nil,
    followersOnly: Int? = nil,
    r9k: Bool? = nil,
    roomID: String,
    slow: UInt? = nil,
    subsOnly: Bool? = nil,
    rituals: Bool? = nil,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.channel = channel
    self.emoteOnly = emoteOnly
    self.followersOnly = followersOnly
    self.r9k = r9k
    self.roomID = roomID
    self.slow = slow
    self.subsOnly = subsOnly
    self.rituals = rituals
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension RoomState: Sendable {}
#endif
