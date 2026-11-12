/// A Twitch `CLEARMESSAGE` message.
public struct ClearMessage {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// The deleted message.
  public private(set) var message = String()
  /// User's name with no uppercased/Han characters.
  /// IRC tag: `login`.
  public private(set) var userLogin = String()
  /// Cleared message's identifier.
  /// IRC tag: `target-msg-id`.
  public private(set) var targetMessageID = String()
  /// Broadcaster's Twitch identifier.
  /// IRC tag: `room-id`.
  public private(set) var roomID = String()
  /// The server timestamp, in milliseconds since the Unix epoch; nil when absent.
  /// IRC tag: `tmi-sent-ts`.
  public private(set) var timestampMilliseconds: UInt?
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard contentRhs.first == "#" else {
      return nil
    }
    /// check for "#" behind channel name
    guard let (channel, message) = contentRhs.dropFirst().componentsOneSplit(separatedBy: " ")
    else { return nil }

    self.channel = String(channel)
    /// `.unicodeScalars.dropFirst()` to remove ":", `componentsOneSplit(separatedBy: " :")`
    /// and other normal methods like a simple `.dropFirst()` fail in rare cases.
    /// Remove `.unicodeScalars` of `PrivateMessage`'s `message` and run tests to find out.
    self.message = String(message.unicodeScalars.dropFirst())

    guard contentLhs.count > 2, contentLhs.last == ":" else {
      return nil
    }
    /// check for ":" at the end

    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.userLogin = parser.string(for: "login")
    self.targetMessageID = parser.string(for: "target-msg-id")
    self.roomID = parser.string(for: "room-id")
    self.timestampMilliseconds = parser.optionalUInt(for: "tmi-sent-ts")

    self.parsingLeftovers = parser.getLeftOvers(excludedUnavailableKeys: ["tmi-sent-ts"])
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    message: String,
    userLogin: String,
    targetMessageID: String,
    roomID: String,
    timestampMilliseconds: UInt? = nil,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.channel = channel
    self.message = message
    self.userLogin = userLogin
    self.targetMessageID = targetMessageID
    self.roomID = roomID
    self.timestampMilliseconds = timestampMilliseconds
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension ClearMessage: Sendable {}
#endif
