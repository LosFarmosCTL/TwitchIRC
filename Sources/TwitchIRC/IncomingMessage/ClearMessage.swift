/// A Twitch `CLEARMESSAGE` message.
public struct ClearMessage {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// The deleted message.
  public private(set) var message = String()
  /// User's name with no uppercased/Han characters.
  public private(set) var userLogin = String()
  /// Cleared message's identifier.
  public private(set) var targetMessageId = String()
  /// Broadcaster's Twitch identifier.
  public private(set) var roomId = String()
  /// Timestamp of this message.
  public private(set) var tmiSentTs = UInt()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

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
    self.targetMessageId = parser.string(for: "target-msg-id")
    self.roomId = parser.string(for: "room-id")
    self.tmiSentTs = parser.uint(for: "tmi-sent-ts")

    self.parsingLeftOvers = parser.getLeftOvers()
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    message: String,
    userLogin: String,
    targetMessageId: String,
    roomId: String,
    tmiSentTs: UInt = UInt(),
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.channel = channel
    self.message = message
    self.userLogin = userLogin
    self.targetMessageId = targetMessageId
    self.roomId = roomId
    self.tmiSentTs = tmiSentTs
    self.parsingLeftOvers = parsingLeftOvers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension ClearMessage: Sendable {}
#endif
