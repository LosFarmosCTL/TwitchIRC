/// A Twitch `CLEARCHAT` message.
public struct ClearChat {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// The cleared user's name, with no uppercased/Han characters.
  /// If `nil` then the whole chat has been cleared.
  public private(set) var userLogin = Optional<String>.none
  /// The duration of the ban/timeout.
  /// If `nil` and `user` available, then the user is permanently banned.
  /// IRC tag: `ban-duration`.
  public private(set) var banDuration = Optional<UInt>.none
  /// Broadcaster's Twitch identifier, when supplied.
  /// IRC tag: `room-id`.
  public private(set) var roomID: String?
  /// The cleared user's Twitch identifier, when supplied.
  /// IRC tag: `target-user-id`.
  public private(set) var targetUserID: String?
  /// The server timestamp, in milliseconds since the Unix epoch; nil when absent.
  /// IRC tag: `tmi-sent-ts`.
  public private(set) var timestampMilliseconds: UInt?

  /// Unconsumed tags and recoverable field-decoding issues.
  public private(set) var parsingLeftovers = ParsingLeftovers()

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
      self.roomID = parser.optionalString(for: "room-id")
      self.targetUserID = parser.optionalString(for: "target-user-id")
      self.timestampMilliseconds = parser.optionalUInt(for: "tmi-sent-ts")
      self.parsingLeftovers = parser.getLeftOvers(
        excludedUnavailableKeys: ["ban-duration", "room-id", "target-user-id", "tmi-sent-ts"])
    }
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    userLogin: String? = Optional<String>.none,
    banDuration: UInt? = Optional<UInt>.none,
    roomID: String? = nil,
    targetUserID: String? = nil,
    timestampMilliseconds: UInt? = nil,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.channel = channel
    self.userLogin = userLogin
    self.banDuration = banDuration
    self.roomID = roomID
    self.targetUserID = targetUserID
    self.timestampMilliseconds = timestampMilliseconds
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension ClearChat: Sendable {}
#endif
