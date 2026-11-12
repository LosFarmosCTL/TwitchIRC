/// A Twitch `USERNOTICE` message.
public struct UserNotice: MessageWithBadges {

  /// Channel's name with no uppercased/Han characters.
  public var channel = String()
  /// Possible message sent by user.
  public var message = String()
  /// User's badge info.
  public var badgeInfo = [String]()
  /// User's badges.
  public var badges = [String]()
  /// User's in-chat name color.
  public var color = String()
  /// User's display name with uppercased/Han characters.
  public var displayName = String()
  /// User is VIP or not. Defaults to false when the unofficial `vip` tag is absent.
  public var vip = Bool()
  /// User's sent emotes.
  public var emotes = String()
  /// Flags of this notice.
  public var flags = [String]()
  /// Message's id.
  public var id = String()
  /// User's name with no uppercased/Han characters.
  public var userLogin = String()
  /// More-precise info about this user notice.
  public var messageId: MessageID!
  /// The notice's `msg-id` exactly as received, including recognized and unknown categories.
  public var rawMessageId = String()
  /// Broadcaster's Twitch identifier.
  public var roomId = String()
  /// Shared Chat origin metadata; empty for notices without source tags.
  public var source = SharedChatSource()
  /// The raw `source-msg-id` notice category, including unknown categories.
  /// This is distinct from the source message's UUID in `source.id`.
  public var sourceMessageId = String()
  /// System's description of this message.
  public var systemMessage = String()
  /// The timestamp of the message.
  public var tmiSentTs = UInt()
  /// User's Twitch identifier.
  public var userId = String()
  /// Contains info about unused info and parsing problems.
  public var parsingLeftOvers = ParsingLeftOvers()

  public func parseEmotes() -> [Emote] {
    Emote.parse(from: emotes, and: message)
  }

  public init() {}

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
    self.sourceMessageId = parser.string(for: "source-msg-id")

    let parsed = MessageID.parse(
      id: messageId == "sharedchatnotice" ? self.sourceMessageId : messageId,
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
}

extension UserNotice: Sendable {}
