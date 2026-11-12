/// A Twitch `GLOBALUSERSTATE` message.
public struct GlobalUserState: MessageWithBadges {

  /// Badge info.
  public private(set) var badgeInfo = [String]()
  /// User's global badges.
  public private(set) var badges = [String]()
  /// User's in-chat name color.
  public private(set) var color: String?
  /// User's display name with uppercased/Han characters.
  public private(set) var displayName = String()
  /// User's emote sets.
  public private(set) var emoteSets = [String]()
  /// User's Twitch identifier.
  public private(set) var userId = String()
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

  internal init() {}

  init(contentLhs: String) {
    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.badgeInfo = parser.array(for: "badge-info")
    self.badges = parser.array(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emoteSets = parser.array(for: "emote-sets")
    self.userId = parser.string(for: "user-id")

    let deprecatedKeys = ["turbo", "user-type"]
    self.parsingLeftOvers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      excludedUnavailableKeys: ["color"]
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    badgeInfo: [String] = [String](),
    badges: [String] = [String](),
    color: String? = nil,
    displayName: String = String(),
    emoteSets: [String] = [String](),
    userId: String,
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.badgeInfo = badgeInfo
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.emoteSets = emoteSets
    self.userId = userId
    self.parsingLeftOvers = parsingLeftOvers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension GlobalUserState: Sendable {}
#endif
