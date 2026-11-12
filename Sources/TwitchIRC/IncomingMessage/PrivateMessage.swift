/// A Twitch `PRIVMSG` message.
public struct PrivateMessage: MessageWithBadges {

  public struct ReplyParent {
    /// Replied user's display name with uppercased/Han characters.
    /// IRC tag: `reply-parent-display-name`.
    public private(set) var displayName: String?
    /// Replied user's name with no uppercased/Han characters.
    /// IRC tag: `reply-parent-user-login`.
    public private(set) var userLogin: String?
    /// The replied message.
    /// IRC tag: `reply-parent-msg-body`.
    public private(set) var message: String?
    /// Replied message's id.
    /// IRC tag: `reply-parent-msg-id`.
    public private(set) var id: String?
    /// Replied user's Twitch identifier.
    /// IRC tag: `reply-parent-user-id`.
    public private(set) var userID: String?

    public init(
      displayName: String? = nil,
      userLogin: String? = nil,
      message: String? = nil,
      id: String?,
      userID: String? = nil
    ) {
      self.displayName = displayName
      self.userLogin = userLogin
      self.message = message
      self.id = id
      self.userID = userID
    }

  }

  public struct ReplyThreadParent {
    /// Replied user's name with no uppercased/Han characters.
    /// IRC tag: `reply-thread-parent-user-login`.
    public private(set) var userLogin: String?
    /// Replied thread's message's id.
    /// IRC tag: `reply-thread-parent-msg-id`.
    public private(set) var messageID: String?
    /// Replied user's display name.
    /// IRC tag: `reply-thread-parent-display-name`.
    public private(set) var displayName: String?
    /// Replied user's user id.
    /// IRC tag: `reply-thread-parent-user-id`.
    public private(set) var userID: String?

    public init(
      userLogin: String? = nil,
      messageID: String?,
      displayName: String? = nil,
      userID: String? = nil
    ) {
      self.userLogin = userLogin
      self.messageID = messageID
      self.displayName = displayName
      self.userID = userID
    }

  }

  public struct PinnedChat {
    /// IRC tag: `pinned-chat-paid-amount`.
    public private(set) var amount: UInt?
    /// IRC tag: `pinned-chat-paid-canonical-amount`.
    public private(set) var canonicalAmount: UInt?
    /// IRC tag: `pinned-chat-paid-currency`.
    public private(set) var currency: String?
    /// IRC tag: `pinned-chat-paid-exponent`.
    public private(set) var exponent: UInt?
    /// IRC tag: `pinned-chat-paid-is-system-message`.
    public private(set) var isSystemMessage: Bool?
    /// IRC tag: `pinned-chat-paid-level`.
    public private(set) var level: String?

    public init(
      amount: UInt?,
      canonicalAmount: UInt? = nil,
      currency: String? = nil,
      exponent: UInt? = nil,
      isSystemMessage: Bool? = nil,
      level: String? = nil
    ) {
      self.amount = amount
      self.canonicalAmount = canonicalAmount
      self.currency = currency
      self.exponent = exponent
      self.isSystemMessage = isSystemMessage
      self.level = level
    }

  }

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// Displayable message text, with properly framed CTCP ACTION markers removed.
  /// Original protocol content remains available in `MessageParseResult.rawMessage`.
  public private(set) var message = String()
  /// Whether the IRC content was framed as `\u{1}ACTION ...\u{1}` (the /me command).
  public private(set) var isAction = false
  /// Badge info.
  /// IRC tag: `badge-info`.
  public private(set) var badgeInfo = [BadgeInfo]()
  /// User's badges.
  /// IRC tag: `badges`.
  public private(set) var badges = [Badge]()
  /// The bits that were donated, if any.
  /// IRC tag: `bits`.
  public private(set) var bits: String?
  /// User's in-chat name color.
  /// IRC tag: `color`.
  public private(set) var color: String?
  /// User's display name with uppercased/Han characters.
  /// IRC tag: `display-name`.
  public private(set) var displayName = String()
  /// User's name with no uppercased/Han characters.
  public private(set) var userLogin = String()
  /// Decoded emote occurrences in message text.
  /// IRC tag: `emotes`; offsets refer to this message's exposed text.
  public private(set) var emotes = [Emote]()
  /// Decoded GIF occurrences in message text.
  /// IRC tag: `gifs`; offsets refer to this message's exposed text.
  public private(set) var gifs = [GIF]()
  /// Whether or not the message only contains emotes.
  /// IRC tag: `emote-only`.
  public private(set) var emoteOnly: Bool?
  /// Flags of this message.
  /// IRC tag: `flags`.
  public private(set) var flags = [String]()
  /// Whether it's the first time the user is sending a message.
  /// IRC tag: `first-msg`.
  public private(set) var firstMessage: Bool?
  /// Flag for new viewers who have chatted at least twice in the last 30 days.
  /// IRC tag: `returning-chatter`.
  public private(set) var returningChatter: Bool?
  /// Twitch's message category, distinct from the unique message `id`; nil when absent.
  /// IRC tag: `msg-id`.
  public private(set) var messageType: String?
  /// Message's id.
  /// IRC tag: `id`.
  public private(set) var id = String()
  /// Identifier of the parent message associated with the crowd chant, when supplied.
  /// IRC tag: `crowd-chant-parent-msg-id`.
  public private(set) var crowdChantParentMessageID: String?
  /// The id of the custom reward, if any.
  /// IRC tag: `custom-reward-id`.
  public private(set) var customRewardID: String?
  /// Broadcaster's Twitch identifier.
  /// IRC tag: `room-id`.
  public private(set) var roomID = String()
  /// Shared Chat origin metadata; nil for messages without source tags.
  public private(set) var source: SharedChatSource?
  /// Whether this Shared Chat message is restricted to the source channel, when specified.
  /// IRC tag: `source-only`.
  public private(set) var sourceOnly: Bool?
  /// The server timestamp, in milliseconds since the Unix epoch; nil when absent.
  /// IRC tag: `tmi-sent-ts`.
  public private(set) var timestampMilliseconds: UInt?
  /// Client-supplied nonce echoed by Twitch, when present.
  /// IRC tag: `client-nonce`.
  public private(set) var clientNonce: String?
  /// User's Twitch identifier.
  /// IRC tag: `user-id`.
  public private(set) var userID = String()
  /// Info about the replied message, if any.
  public private(set) var replyParent: ReplyParent?
  /// Info about the thread of the replied message, if any.
  public private(set) var replyThreadParent: ReplyThreadParent?
  /// Info of paid pinned messages.
  public private(set) var pinnedChat: PinnedChat?
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard parseContent(contentRhs),
      let (infoPart, userLoginPart) = contentLhs.componentsOneSplit(separatedBy: " :"),
      let userLogin = Self.parseSender(userLoginPart)
    else { return nil }
    self.userLogin = userLogin
    let content = MessageText(message)
    self.message = content.text
    self.isAction = content.isAction
    var parser = ParametersParser(String(infoPart.dropFirst()))
    parseTags(&parser)
    parseLeftOvers(&parser)
  }

  private mutating func parseContent(_ contentRhs: String) -> Bool {
    guard contentRhs.count > 3, contentRhs.first == "#" else {
      return false
    }
    /// check existence of " #" before the channel name
    guard
      let (channel, message) = String(contentRhs.dropFirst()).componentsOneSplit(
        separatedBy: " "
      )
    else {
      return false
    }
    /// separating with " ", then lhs contains channel name and rhs is the actual message
    self.channel = channel

    /// Remove colon prefix if present
    if message.unicodeScalars.first == ":" {
      /// `.unicodeScalars.dropFirst()` to remove ":", `componentsOneSplit(separatedBy: " :")`
      /// and other normal methods like a simple `.dropFirst()` fail in rare cases.
      /// Remove `.unicodeScalars` and run tests to find out.
      self.message = String(message.unicodeScalars.dropFirst())
    } else {
      self.message = message
    }

    return true
  }

  private static func parseSender(_ userLoginPart: String) -> String? {
    /// separates "senderName!senderName@senderName." from what is behind it.

    guard let (userLogin1, theRest) = userLoginPart.dropLast().componentsOneSplit(separatedBy: "!"),
      let (userLogin2, userLogin3) = theRest.componentsOneSplit(separatedBy: "@"),
      userLogin1 == userLogin2, userLogin2 == userLogin3
    else {
      return nil
    }
    return String(userLogin1)

  }

  private mutating func parseTags(_ parser: inout ParametersParser) {
    self.badgeInfo = parser.badgeInfo(for: "badge-info")
    self.badges = parser.badges(for: "badges")
    self.bits = parser.optionalNonEmptyString(for: "bits")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emotes = parser.emotes(in: self.message)
    self.gifs = parser.gifs(in: self.message)
    self.emoteOnly = parser.optionalBool(for: "emote-only")
    self.flags = parser.array(for: "flags")
    self.firstMessage = parser.optionalBool(for: "first-msg")
    self.returningChatter = parser.optionalBool(for: "returning-chatter")
    self.messageType = parser.optionalNonEmptyString(for: "msg-id")
    self.id = parser.string(for: "id")
    self.crowdChantParentMessageID = parser.optionalNonEmptyString(for: "crowd-chant-parent-msg-id")
    self.customRewardID = parser.optionalNonEmptyString(for: "custom-reward-id")
    self.roomID = parser.string(for: "room-id")
    self.source = SharedChatSource(parser: &parser)
    self.sourceOnly = parser.optionalBool(for: "source-only")
    self.timestampMilliseconds = parser.optionalUInt(for: "tmi-sent-ts")
    self.clientNonce = parser.optionalNonEmptyString(for: "client-nonce")
    self.userID = parser.string(for: "user-id")
    self.replyParent = .init(parser: &parser)
    self.replyThreadParent = .init(parser: &parser)
    self.pinnedChat = .init(parser: &parser)

  }

  private mutating func parseLeftOvers(_ parser: inout ParametersParser) {
    let deprecatedKeys = ["turbo", "mod", "vip", "subscriber", "user-type"]
    let occasionalKeys = [
      ["crowd-chant-parent-msg-id"], ["bits"], ["gifs"], ["emote-only"], ["msg-id"],
      ["custom-reward-id"], ["client-nonce"], ["flags"], ["first-msg"],
      ["returning-chatter"], ["color"], ["tmi-sent-ts"],
      [
        "reply-parent-display-name", "reply-parent-user-login", "reply-parent-msg-body",
        "reply-parent-msg-id", "reply-parent-user-id",
      ],
      [
        "pinned-chat-paid-amount", "pinned-chat-paid-canonical-amount", "pinned-chat-paid-currency",
        "pinned-chat-paid-exponent",
      ], ["pinned-chat-paid-is-system-message", "pinned-chat-paid-level"],
      ["reply-thread-parent-user-login", "reply-thread-parent-msg-id"],
      ["reply-thread-parent-display-name", "reply-thread-parent-user-id"],
    ]

    self.parsingLeftovers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      groupsOfExcludedUnavailableKeys: occasionalKeys + [SharedChatSource.tagKeys, ["source-only"]]
    )
  }

  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    message: String,
    isAction: Bool = false,
    badgeInfo: [BadgeInfo] = [],
    badges: [Badge] = [],
    bits: String? = nil,
    color: String? = nil,
    displayName: String = String(),
    userLogin: String,
    emotes: [Emote] = [],
    gifs: [GIF] = [],
    emoteOnly: Bool? = nil,
    flags: [String] = [String](),
    firstMessage: Bool? = nil,
    returningChatter: Bool? = nil,
    messageType: String? = nil,
    id: String,
    crowdChantParentMessageID: String? = nil,
    customRewardID: String? = nil,
    roomID: String,
    source: SharedChatSource? = nil,
    sourceOnly: Bool? = nil,
    timestampMilliseconds: UInt? = nil,
    clientNonce: String? = nil,
    userID: String,
    replyParent: ReplyParent? = nil,
    replyThreadParent: ReplyThreadParent? = nil,
    pinnedChat: PinnedChat? = nil,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.channel = channel
    self.message = message
    self.isAction = isAction
    self.badgeInfo = badgeInfo
    self.badges = badges
    self.bits = bits
    self.color = color
    self.displayName = displayName
    self.userLogin = userLogin
    self.emotes = emotes
    self.gifs = gifs
    self.emoteOnly = emoteOnly
    self.flags = flags
    self.firstMessage = firstMessage
    self.returningChatter = returningChatter
    self.messageType = messageType
    self.id = id
    self.crowdChantParentMessageID = crowdChantParentMessageID
    self.customRewardID = customRewardID
    self.roomID = roomID
    self.source = source
    self.sourceOnly = sourceOnly
    self.timestampMilliseconds = timestampMilliseconds
    self.clientNonce = clientNonce
    self.userID = userID
    self.replyParent = replyParent
    self.replyThreadParent = replyThreadParent
    self.pinnedChat = pinnedChat
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformances
#if swift(>=5.5)
  extension PrivateMessage: Sendable {}
  extension PrivateMessage.ReplyParent: Sendable {}
  extension PrivateMessage.ReplyThreadParent: Sendable {}
  extension PrivateMessage.PinnedChat: Sendable {}
#endif

extension PrivateMessage.ReplyParent {
  init?(parser: inout ParametersParser) {
    guard parser.contains(prefix: "reply-parent-") else { return nil }
    self.init(
      displayName: parser.optionalNonEmptyString(for: "reply-parent-display-name"),
      userLogin: parser.optionalNonEmptyString(for: "reply-parent-user-login"),
      message: parser.optionalNonEmptyString(for: "reply-parent-msg-body"),
      id: parser.optionalNonEmptyString(for: "reply-parent-msg-id"),
      userID: parser.optionalNonEmptyString(for: "reply-parent-user-id")
    )
  }
}

extension PrivateMessage.ReplyThreadParent {
  init?(parser: inout ParametersParser) {
    guard parser.contains(prefix: "reply-thread-parent-") else { return nil }
    self.init(
      userLogin: parser.optionalNonEmptyString(for: "reply-thread-parent-user-login"),
      messageID: parser.optionalNonEmptyString(for: "reply-thread-parent-msg-id"),
      displayName: parser.optionalNonEmptyString(for: "reply-thread-parent-display-name"),
      userID: parser.optionalNonEmptyString(for: "reply-thread-parent-user-id")
    )
  }
}

extension PrivateMessage.PinnedChat {
  init?(parser: inout ParametersParser) {
    guard parser.contains(prefix: "pinned-chat-") else { return nil }
    self.init(
      amount: parser.optionalUInt(for: "pinned-chat-paid-amount"),
      canonicalAmount: parser.optionalUInt(for: "pinned-chat-paid-canonical-amount"),
      currency: parser.optionalNonEmptyString(for: "pinned-chat-paid-currency"),
      exponent: parser.optionalUInt(for: "pinned-chat-paid-exponent"),
      isSystemMessage: parser.optionalBool(for: "pinned-chat-paid-is-system-message"),
      level: parser.optionalNonEmptyString(for: "pinned-chat-paid-level")
    )
  }
}
