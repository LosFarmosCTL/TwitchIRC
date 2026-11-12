/// A Twitch `USERSTATE` message.
public struct UserState: MessageWithBadges {

  /// Channel's name with no uppercased/Han characters.
  public private(set) var channel = String()
  /// User's badge info.
  public private(set) var badgeInfo = [String]()
  /// User's badges.
  public private(set) var badges = [String]()
  /// User's in-chat name color.
  public private(set) var color: String?
  /// User's display name with uppercased/Han characters.
  public private(set) var displayName = String()
  /// User's emote sets.
  public private(set) var emoteSets = [String]()
  /// The ID of this user state message.
  public private(set) var id: String?
  /// The nonce sent by client in the PRIVMSG.
  public private(set) var clientNonce: String?
  /// Contains info about unused info and parsing problems.
  public private(set) var parsingLeftOvers = ParsingLeftOvers()

  internal init() {}

  init?(contentLhs: String, contentRhs: String) {
    guard contentRhs.first == "#", contentLhs.count > 2 else {
      return nil
    }
    self.channel = String(contentRhs.dropFirst())

    var parser = ParametersParser(String(contentLhs.dropLast(2).dropFirst()))

    self.badgeInfo = parser.array(for: "badge-info")
    self.badges = parser.array(for: "badges")
    self.color = parser.optionalNonEmptyString(for: "color")
    self.displayName = parser.string(for: "display-name")
    self.emoteSets = parser.array(for: "emote-sets")
    self.clientNonce = parser.optionalString(for: "client-nonce")
    self.id = parser.optionalNonEmptyString(for: "id")

    let deprecatedKeys = ["turbo", "mod", "subscriber", "user-type"]
    let sometimesUnavailableKeys = ["id", "client-nonce", "color"]
    self.parsingLeftOvers = parser.getLeftOvers(
      excludedUnusedKeys: deprecatedKeys,
      excludedUnavailableKeys: sometimesUnavailableKeys
    )
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    channel: String,
    badgeInfo: [String] = [String](),
    badges: [String] = [String](),
    color: String? = nil,
    displayName: String = String(),
    emoteSets: [String] = [String](),
    id: String? = nil,
    clientNonce: String? = nil,
    parsingLeftOvers: ParsingLeftOvers = ParsingLeftOvers()
  ) {
    self.channel = channel
    self.badgeInfo = badgeInfo
    self.badges = badges
    self.color = color
    self.displayName = displayName
    self.emoteSets = emoteSets
    self.id = id
    self.clientNonce = clientNonce
    self.parsingLeftOvers = parsingLeftOvers
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension UserState: Sendable {}
#endif
