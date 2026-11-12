/// A Twitch `USERNOTICE` message.
public struct UserNotice: MessageWithBadges {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// Possible message sent by user.
  public private(set) var message = String()
  /// User's badge info.
  /// IRC tag: `badge-info`.
  public private(set) var badgeInfo = [BadgeInfo]()
  /// User's badges.
  /// IRC tag: `badges`.
  public private(set) var badges = [Badge]()
  /// User's in-chat name color.
  /// IRC tag: `color`.
  public private(set) var color: String?
  /// User's display name with uppercased/Han characters.
  /// IRC tag: `display-name`.
  public private(set) var displayName = String()
  /// The unofficial VIP flag, or nil when absent. Prefer the badge-based `isVIP` property.
  /// IRC tag: `vip`.
  public private(set) var vip: Bool?
  /// User's sent emotes.
  /// IRC tag: `emotes`; offsets refer to this message's exposed text.
  public private(set) var emotes = [Emote]()
  /// Flags of this notice.
  /// IRC tag: `flags`.
  public private(set) var flags = [String]()
  /// Message's id.
  /// IRC tag: `id`.
  public private(set) var id = String()
  /// User's name with no uppercased/Han characters.
  /// IRC tag: `login`.
  public private(set) var userLogin = String()
  /// More-precise info about this user notice.
  /// IRC tag: `msg-id`.
  public private(set) var kind: Kind
  /// The notice's `msg-id` exactly as received, including recognized and unknown categories.
  /// IRC tag: `msg-id`.
  public private(set) var rawKind = String()
  /// Broadcaster's Twitch identifier.
  /// IRC tag: `room-id`.
  public private(set) var roomID = String()
  /// Shared Chat origin metadata; nil for notices without source tags.
  public private(set) var source: SharedChatSource?
  /// The raw `source-msg-id` notice category, including unknown categories.
  /// This is distinct from the source message's UUID in `source.id`.
  /// IRC tag: `source-msg-id`.
  public private(set) var sourceKind: String?
  /// System's description of this message.
  /// IRC tag: `system-msg`.
  public private(set) var systemMessage = String()
  /// The server timestamp, in milliseconds since the Unix epoch; nil when absent.
  /// IRC tag: `tmi-sent-ts`.
  public private(set) var timestampMilliseconds: UInt?
  /// User's Twitch identifier.
  /// IRC tag: `user-id`.
  public private(set) var userID = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

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
    guard let kind = parser.optionalString(for: "msg-id"), !kind.isEmpty else {
      return nil
    }
    self.rawKind = kind
    let sourceKind = parser.optionalNonEmptyString(for: "source-msg-id")
    self.sourceKind = sourceKind

    let parsed = Kind.parse(
      id: kind == "sharedchatnotice" ? sourceKind : kind,
      parser: &parser
    )
    let occasionalSubDependentKeyGroups = parsed?.optionalKeyGroups ?? []

    if kind == "sharedchatnotice" {
      self.kind = .sharedChatNotice(sourceNotice: parsed?.kind)
    } else {
      self.kind = parsed?.kind ?? .unknown(rawKind: kind)
    }

    parseCommonTags(&parser)

    let deprecatedKeys = ["turbo", "mod", "subscriber", "user-type"]
    let occasionalKeys: [[String]] =
      occasionalSubDependentKeyGroups + [["flags"], ["vip"], ["color"], ["tmi-sent-ts"]]
    self.parsingLeftovers = parser.getLeftOvers(
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
    self.roomID = parser.string(for: "room-id")
    self.source = SharedChatSource(parser: &parser)
    self.systemMessage = parser.string(for: "system-msg")
    self.timestampMilliseconds = parser.optionalUInt(for: "tmi-sent-ts")
    self.userID = parser.string(for: "user-id")

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
    kind: Kind,
    rawKind: String,
    roomID: String,
    source: SharedChatSource? = nil,
    sourceKind: String? = nil,
    systemMessage: String = String(),
    timestampMilliseconds: UInt? = nil,
    userID: String,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
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
    self.kind = kind
    self.rawKind = rawKind
    self.roomID = roomID
    self.source = source
    self.sourceKind = sourceKind
    self.systemMessage = systemMessage
    self.timestampMilliseconds = timestampMilliseconds
    self.userID = userID
    self.parsingLeftovers = parsingLeftovers
  }
}

extension UserNotice: Sendable {}
