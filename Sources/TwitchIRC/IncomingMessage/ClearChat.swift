/// A Twitch `CLEARCHAT` message.
public struct ClearChat {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// The cleared user's name, with no uppercased/Han characters.
  /// If `nil` then the whole chat has been cleared.
  public private(set) var userLogin = Optional<String>.none
  /// The duration of the ban/timeout.
  /// If `nil` and `user` available, then the user is permanently banned.
  public private(set) var banDuration = Optional<UInt>.none
  /// Broadcaster's Twitch identifier, when supplied.
  public private(set) var roomId: String?
  /// The cleared user's Twitch identifier, when supplied.
  public private(set) var targetUserId: String?
  /// Timestamp in milliseconds since the Unix epoch, when supplied.
  public private(set) var tmiSentTs: UInt?

  /// Unconsumed tags and recoverable field-decoding issues.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

  // MARK: Convenience stuff
  public var userIsPermanentlyBanned: Bool {
    banDuration == nil && userLogin != nil
  }

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard contentRhs.first == "#" else {
      return nil
    }
    /// check for "#" behind channel name

    if let (channel, user) = contentRhs.dropFirst().componentsOneSplit(separatedBy: " :") {
      self.channel = String(channel)
      self.userLogin = String(user)
    } else {
      /// the whole chat has been cleared therefore there is no " :" to specify the user.
      self.channel = String(contentRhs.dropFirst())
    }

    if contentLhs.hasPrefix("@") {
      var parser = ParametersParser(String(contentLhs.dropFirst().dropLast(2)))
      self.banDuration = parser.optionalUInt(for: "ban-duration")
      self.roomId = parser.optionalString(for: "room-id")
      self.targetUserId = parser.optionalString(for: "target-user-id")
      self.tmiSentTs = parser.optionalUInt(for: "tmi-sent-ts")
      self.parsingLeftOvers = parser.getLeftOvers(
        excludedUnavailableKeys: ["ban-duration", "room-id", "target-user-id", "tmi-sent-ts"])
    }
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    userLogin: String? = Optional<String>.none,
    banDuration: UInt? = Optional<UInt>.none,
    roomId: String? = nil,
    targetUserId: String? = nil,
    tmiSentTs: UInt? = nil,
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.channel = channel
    self.userLogin = userLogin
    self.banDuration = banDuration
    self.roomId = roomId
    self.targetUserId = targetUserId
    self.tmiSentTs = tmiSentTs
    self.parsingLeftOvers = parsingLeftOvers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension ClearChat: Sendable {}
#endif
