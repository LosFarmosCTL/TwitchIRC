/// A Twitch `USERNOTICE` message.
public struct UserNotice: MessageWithBadges {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// Possible message sent by user.
  public private(set) var message = String()
  /// User's badge info.
  public private(set) var badgeInfo = [BadgeInfo]()
  /// User's badges.
  public private(set) var badges = [Badge]()
  /// User's in-chat name color.
  public private(set) var color: String?
  /// User's display name with uppercased/Han characters.
  public private(set) var displayName = String()
  /// The unofficial VIP flag, or nil when absent. Prefer the badge-based `isVIP` property.
  public private(set) var vip: Bool?
  /// User's sent emotes.
  public private(set) var emotes = [Emote]()
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
  /// Shared Chat origin metadata; nil for notices without source tags.
  public private(set) var source: SharedChatSource?
  /// The raw `source-msg-id` notice category, including unknown categories.
  /// This is distinct from the source message's UUID in `source.id`.
  public private(set) var sourceMessageId: String?
  /// System's description of this message.
  public private(set) var systemMessage = String()
  /// The timestamp of the message.
  public private(set) var tmiSentTs: UInt?
  /// User's Twitch identifier.
  public private(set) var userId = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

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
    let sourceMessageId = parser.optionalNonEmptyString(for: "source-msg-id")
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

    parseCommonTags(&parser)

    let deprecatedKeys = ["turbo", "mod", "subscriber", "user-type"]
    let occasionalKeys: [[String]] =
      occasionalSubDependentKeyGroups + [["flags"], ["vip"], ["color"], ["tmi-sent-ts"]]
    self.parsingLeftOvers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      groupsOfExcludedUnavailableKeys: occasionalKeys + [
        SharedChatSource.tagKeys, ["source-msg-id"],
      ]
    )
  }
  private mutating func parseCommonTags(_ parser: inout ParametersParser) {
    self.badgeInfo = parser.badgeInfo(for: "badge-info")
    self.badges = parser.badges(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.vip = parser.optionalBool(for: "vip")
    self.emotes = parser.emotes(in: self.message)
    self.flags = parser.array(for: "flags")
    self.id = parser.string(for: "id")
    self.userLogin = parser.string(for: "login")
    self.roomId = parser.string(for: "room-id")
    self.source = SharedChatSource(parser: &parser)
    self.systemMessage = parser.string(for: "system-msg")
    self.tmiSentTs = parser.optionalUInt(for: "tmi-sent-ts")
    self.userId = parser.string(for: "user-id")

  }

  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    message: String = String(),
    badgeInfo: [BadgeInfo] = [],
    badges: [Badge] = [],
    color: String? = nil,
    displayName: String = String(),
    vip: Bool? = nil,
    emotes: [Emote] = [],
    flags: [String] = [String](),
    id: String,
    userLogin: String,
    messageId: MessageID,
    rawMessageId: String,
    roomId: String,
    source: SharedChatSource? = nil,
    sourceMessageId: String? = nil,
    systemMessage: String = String(),
    tmiSentTs: UInt? = nil,
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
