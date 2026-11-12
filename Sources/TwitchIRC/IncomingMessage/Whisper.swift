public struct Whisper: MessageWithBadges {

  /// The receiver of this whisper. All lowercased.
  public private(set) var receiver = String()
  /// The message sent.
  public private(set) var message = String()
  /// Sender's badges.
  public private(set) var badges = [String]()
  /// Sender's in-chat name color.
  public private(set) var color: String?
  /// Sender's display name with uppercased/Han characters.
  public private(set) var displayName = String()
  /// Sender's emotes.
  public private(set) var emotes = [Emote]()
  /// Message's identifier.
  public private(set) var messageId: String?
  /// This whisper-thread's identifier.
  public private(set) var threadId: String?
  /// Sender's Twitch identifier.
  public private(set) var userId = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

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

    self.badges = parser.array(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emotes = parser.emotes(in: self.message)
    self.messageId = parser.optionalNonEmptyString(for: "message-id")
    self.threadId = parser.optionalNonEmptyString(for: "thread-id")
    self.userId = parser.string(for: "user-id")

    let deprecatedKeys = ["turbo", "user-type"]
    self.parsingLeftOvers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      excludedUnavailableKeys: ["color", "message-id", "thread-id"]
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    receiver: String,
    message: String,
    badges: [String] = [String](),
    color: String? = nil,
    displayName: String = String(),
    emotes: [Emote] = [],
    messageId: String? = nil,
    threadId: String? = nil,
    userId: String,
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.receiver = receiver
    self.message = message
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.emotes = emotes
    self.messageId = messageId
    self.threadId = threadId
    self.userId = userId
    self.parsingLeftOvers = parsingLeftOvers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension Whisper: Sendable {}
#endif
