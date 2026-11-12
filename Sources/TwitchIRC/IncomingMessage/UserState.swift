/// A Twitch `USERSTATE` message.
public struct UserState: MessageWithBadges {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
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
  /// User's emote sets.
  /// IRC tag: `emote-sets`.
  public private(set) var emoteSets = [String]()
  /// The ID of this user state message.
  /// IRC tag: `id`.
  public private(set) var id: String?
  /// Client-supplied nonce echoed by Twitch, when present.
  /// IRC tag: `client-nonce`.
  public private(set) var clientNonce: String?
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard contentRhs.first == "#", contentLhs.count > 2 else {
      return nil
    }
    self.channel = String(contentRhs.dropFirst())

    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.badgeInfo = parser.badgeInfo(for: "badge-info")
    self.badges = parser.badges(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emoteSets = parser.array(for: "emote-sets")
    self.clientNonce = parser.optionalString(for: "client-nonce")
    self.id = parser.optionalNonEmptyString(for: "id")

    let deprecatedKeys = ["turbo", "mod", "subscriber", "user-type"]
    let sometimesUnavailableKeys = ["id", "client-nonce", "color"]
    self.parsingLeftovers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      excludedUnavailableKeys: sometimesUnavailableKeys
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    badgeInfo: [BadgeInfo] = [],
    badges: [Badge] = [],
    color: String? = nil,
    displayName: String = String(),
    emoteSets: [String] = [String](),
    id: String? = nil,
    clientNonce: String? = nil,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.channel = channel
    self.badgeInfo = badgeInfo
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.emoteSets = emoteSets
    self.id = id
    self.clientNonce = clientNonce
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension UserState: Sendable {}
#endif
