/// A Twitch `USERNOTICE` message.
public struct UserNotice: MessageWithBadges {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// Possible message sent by user.
  public private(set) var message = String()
  /// User's badge info.
  public private(set) var badgeInfo = [String]()
  /// User's badges.
  public private(set) var badges = [String]()
  /// User's in-chat name color.
  public private(set) var color = String()
  /// User's display name with uppercased/Han characters.
  public private(set) var displayName = String()
  /// User is VIP or not. Defaults to false when the unofficial `vip` tag is absent.
  public private(set) var vip = Bool()
  /// User's sent emotes.
  public private(set) var emotes = String()
  /// Flags of this notice.
  public private(set) var flags = [String]()
  /// Message's id.
  public private(set) var id = String()
  /// User's name with no uppercased/Han characters.
  public private(set) var userLogin = String()
  /// More-precise info about this user notice.
  public private(set) var messageId: MessageID
  /// The notice's `msg-id` exactly as received, including recognized and unknown categories.
  public private(set) var rawMessageId = String()
  /// Broadcaster's Twitch identifier.
  public private(set) var roomId = String()
  /// Shared Chat origin metadata; empty for notices without source tags.
  public private(set) var source = SharedChatSource()
  /// The raw `source-msg-id` notice category, including unknown categories.
  /// This is distinct from the source message's UUID in `source.id`.
  public private(set) var sourceMessageId = String()
  /// System's description of this message.
  public private(set) var systemMessage = String()
  /// The timestamp of the message.
  public private(set) var tmiSentTs = UInt()
  /// User's Twitch identifier.
  public private(set) var userId = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

  public func parseEmotes() -> [Emote] {
    Emote.parse(from: emotes, and: message)
  }

  init?(contentLhs: String, contentRhs: String) {
    guard contentRhs.first == "#", contentLhs.count > 2 else {
      return nil
    }

    if let (channel, message) = String(contentRhs.dropFirst()).componentsOneSplit(
      separatedBy: " "
    ) {
      self.channel = channel
      /// `.unicodeScalars.dropFirst()` to remove ":", `componentsOneSplit(separatedBy: " :")`
      /// and other normal methods like a simple `.dropFirst()` fail in rare cases.
      /// Remove `.unicodeScalars` of `PrivateMessage`'s `message` and run tests to find out.
      self.message = String(message.unicodeScalars.dropFirst())
    } else {
      self.channel = String(contentRhs.dropFirst())
    }

    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))
    guard let messageId = parser.optionalString(for: "msg-id"), !messageId.isEmpty else {
      return nil
    }
    self.rawMessageId = messageId
    let sourceMessageId = parser.string(for: "source-msg-id")
    self.sourceMessageId = sourceMessageId

    let parsed = MessageID.parse(
      id: messageId == "sharedchatnotice" ? sourceMessageId : messageId,
      parser: &parser
    )
    let occasionalSubDependentKeyGroups = parsed?.optionalKeyGroups ?? []

    if messageId == "sharedchatnotice" {
      self.messageId = .sharedChatNotice(sourceNotice: parsed?.messageId)
    } else {
      self.messageId = parsed?.messageId ?? .unknown(rawMessageId: messageId)
    }

    self.badgeInfo = parser.array(for: "badge-info")
    self.badges = parser.array(for: "badges")
    self.color = parser.string(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.vip = parser.bool(for: "vip")
    self.emotes = parser.string(for: "emotes")
    self.flags = parser.array(for: "flags")
    self.id = parser.string(for: "id")
    self.userLogin = parser.string(for: "login")
    self.roomId = parser.string(for: "room-id")
    self.source = SharedChatSource(parser: &parser)
    self.systemMessage = parser.string(for: "system-msg")
    self.tmiSentTs = parser.uint(for: "tmi-sent-ts")
    self.userId = parser.string(for: "user-id")

    let deprecatedKeys = ["turbo", "mod", "subscriber", "user-type"]
    let occasionalKeys: [[String]] = occasionalSubDependentKeyGroups + [["flags"], ["vip"]]
    self.parsingLeftOvers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      groupsOfExcludedUnavailableKeys: occasionalKeys + [
        SharedChatSource.tagKeys, ["source-msg-id"],
      ]
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    message: String = String(),
    badgeInfo: [String] = [String](),
    badges: [String] = [String](),
    color: String = String(),
    displayName: String = String(),
    vip: Bool = Bool(),
    emotes: String = String(),
    flags: [String] = [String](),
    id: String,
    userLogin: String,
    messageId: MessageID,
    rawMessageId: String,
    roomId: String,
    source: SharedChatSource,
    sourceMessageId: String = String(),
    systemMessage: String = String(),
    tmiSentTs: UInt = UInt(),
    userId: String,
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.channel = channel
    self.message = message
    self.badgeInfo = badgeInfo
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.vip = vip
    self.emotes = emotes
    self.flags = flags
    self.id = id
    self.userLogin = userLogin
    self.messageId = messageId
    self.rawMessageId = rawMessageId
    self.roomId = roomId
    self.source = source
    self.sourceMessageId = sourceMessageId
    self.systemMessage = systemMessage
    self.tmiSentTs = tmiSentTs
    self.userId = userId
    self.parsingLeftOvers = parsingLeftOvers
  }
}

extension UserNotice: Sendable {}
