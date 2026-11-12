/// A Twitch `GLOBALUSERSTATE` message.
public struct GlobalUserState: MessageWithBadges {

  /// Badge info.
  /// IRC tag: `badge-info`.
  public private(set) var badgeInfo = [BadgeInfo]()
  /// User's global badges.
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
  /// User's Twitch identifier.
  /// IRC tag: `user-id`.
  public private(set) var userID = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftovers = ParsingLeftovers()

  internal init() {}

  init(contentLhs: String) {
    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.badgeInfo = parser.badgeInfo(for: "badge-info")
    self.badges = parser.badges(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emoteSets = parser.array(for: "emote-sets")
    self.userID = parser.string(for: "user-id")

    let deprecatedKeys = ["turbo", "user-type"]
    self.parsingLeftovers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      excludedUnavailableKeys: ["color"]
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    badgeInfo: [BadgeInfo] = [],
    badges: [Badge] = [],
    color: String? = nil,
    displayName: String = String(),
    emoteSets: [String] = [String](),
    userID: String,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.badgeInfo = badgeInfo
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.emoteSets = emoteSets
    self.userID = userID
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension GlobalUserState: Sendable {}
#endif
