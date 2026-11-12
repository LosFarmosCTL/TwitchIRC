public struct Whisper: MessageWithBadges {

  /// The receiver of this whisper. All lowercased.
  public private(set) var receiver = String()
  /// The message sent.
  public private(set) var message = String()
  /// Sender's badges.
  /// IRC tag: `badges`.
  public private(set) var badges = [Badge]()
  /// Sender's in-chat name color.
  /// IRC tag: `color`.
  public private(set) var color: String?
  /// Sender's display name with uppercased/Han characters.
  /// IRC tag: `display-name`.
  public private(set) var displayName = String()
  /// Sender's emotes.
  /// IRC tag: `emotes`; offsets refer to this message's exposed text.
  public private(set) var emotes = [Emote]()
  /// Message's identifier.
  /// IRC tag: `message-id`.
  public private(set) var messageID: String?
  /// This whisper-thread's identifier.
  /// IRC tag: `thread-id`.
  public private(set) var threadID: String?
  /// Sender's Twitch identifier.
  /// IRC tag: `user-id`.
  public private(set) var userID = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard let (receiver, message) = contentRhs.componentsOneSplit(separatedBy: " ") else {
      return nil
    }
    /// separating with " ", then lhs is the receiver and rhs is the actual message

    self.receiver = receiver
    /// `.unicodeScalars.dropFirst()` to remove ":", `componentsOneSplit(separatedBy: " :")`
    /// and other normal methods like a simple `.dropFirst()` fail in rare cases.
    /// Remove `.unicodeScalars` of `PrivateMessage`'s `message` and run tests to find out.
    self.message = String(message.unicodeScalars.dropFirst())

    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.badges = parser.badges(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emotes = parser.emotes(in: self.message)
    self.messageID = parser.optionalNonEmptyString(for: "message-id")
    self.threadID = parser.optionalNonEmptyString(for: "thread-id")
    self.userID = parser.string(for: "user-id")

    let deprecatedKeys = ["turbo", "user-type"]
    self.parsingLeftovers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      excludedUnavailableKeys: ["color", "message-id", "thread-id"]
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    receiver: String,
    message: String,
    badges: [Badge] = [],
    color: String? = nil,
    displayName: String = String(),
    emotes: [Emote] = [],
    messageID: String? = nil,
    threadID: String? = nil,
    userID: String,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.receiver = receiver
    self.message = message
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.emotes = emotes
    self.messageID = messageID
    self.threadID = threadID
    self.userID = userID
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension Whisper: Sendable {}
#endif
