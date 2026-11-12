/// A message coming from Twitch.
public enum IncomingMessage {
  /// A type of message sent after successful connection to Twitch.
  case connectionNotice(ConnectionNotice)
  /// A type of message sent after entering a channel.
  case channelEntrance(ChannelEntrance)
  /// A Twitch error indicating the command you sent is unknown.
  case unknownCommand(UnknownCommand)
  /// The global user state of the account connected to Twitch.
  case globalUserState(GlobalUserState)
  /// A normal chat message.
  case privateMessage(PrivateMessage)
  /// A message indicating successful join to a channel.
  case join(Join)
  /// A message indicating successful part from a channel.
  case part(Part)
  /// A message indicating full-chat removal, of a user or of all chatters together.
  case clearChat(ClearChat)
  /// A message indicating removal of a single other message.
  case clearMessage(ClearMessage)
  /// A message indicating host/unhost actions of a channel.
  case hostTarget(HostTarget)
  /// A message giving general notices.
  case notice(Notice)
  /// A message indicating Twitch closing all connections for a short period.
  case reconnect
  /// A message indicating a channel's general room state.
  case roomState(RoomState)
  /// A message giving notices about user actions.
  case userNotice(UserNotice)
  /// A message indicating a user's state in a channel.
  case userState(UserState)
  /// A message indicating given capabilities after requesting them.
  case capabilities(Capabilities)
  /// A whisper aka Twitch private message.
  case whisper(Whisper)
  /// A ping.
  case ping
  /// A pong.
  case pong

  /// Parses all messages included.
  public static func parse(ircOutput: String) -> [(message: Self?, text: String)] {
    ircOutput.componentsSeparatedBy(separator: "\r\n")
      .filter({ !$0.isEmpty })
      .map({ (parseMessage(message: $0), $0) })
  }

  private static func parseMessage(message: String) -> Self? {
    guard let (contentLhs, messageRhs) = message.componentsOneSplit(separatedBy: "tmi.twitch.tv")
    else {
      return nil
    }
    let rhs = String(messageRhs.dropFirst())
    let (identifier, contentRhs) = rhs.componentsOneSplit(separatedBy: " ") ?? (rhs, "")
    if identifier.isEmpty {
      return parseHeartbeat(contentLhs)
    }
    if let numeric = parseNumericReply(identifier, contentRhs: contentRhs) {
      return numeric
    }
    return commandParsers[identifier]?(contentLhs, contentRhs)
  }

  private static func parseHeartbeat(_ content: String) -> Self? {
    switch content {
    case "PING :": return .ping
    case "PONG :": return .pong
    default: return nil
    }
  }

  private static func parseNumericReply(_ identifier: String, contentRhs: String) -> Self? {
    switch identifier {
    case "001", "002", "003", "004", "372", "375", "376":
      return ConnectionNotice(id: identifier, contentRhs: contentRhs).map(Self.connectionNotice)
    case "353", "366":
      return ChannelEntrance(id: identifier, contentRhs: contentRhs).map(Self.channelEntrance)
    case "421":
      return UnknownCommand(contentRhs: contentRhs).map(Self.unknownCommand)
    default: return nil
    }
  }

  private static let commandParsers: [String: @Sendable (String, String) -> Self?] = [
    "GLOBALUSERSTATE": { lhs, _ in .globalUserState(GlobalUserState(contentLhs: lhs)) },
    "PRIVMSG": { lhs, rhs in
      PrivateMessage(contentLhs: lhs, contentRhs: rhs).map(Self.privateMessage)
    },
    "JOIN": { lhs, rhs in Join(contentLhs: lhs, contentRhs: rhs).map(Self.join) },
    "PART": { lhs, rhs in Part(contentLhs: lhs, contentRhs: rhs).map(Self.part) },
    "CLEARCHAT": { lhs, rhs in ClearChat(contentLhs: lhs, contentRhs: rhs).map(Self.clearChat) },
    "CLEARMSG": { lhs, rhs in ClearMessage(contentLhs: lhs, contentRhs: rhs).map(Self.clearMessage)
    },
    "HOSTTARGET": { _, rhs in HostTarget(contentRhs: rhs).map(Self.hostTarget) },
    "NOTICE": { lhs, rhs in Notice(contentLhs: lhs, contentRhs: rhs).map(Self.notice) },
    "ROOMSTATE": { lhs, rhs in RoomState(contentLhs: lhs, contentRhs: rhs).map(Self.roomState) },
    "USERNOTICE": { lhs, rhs in UserNotice(contentLhs: lhs, contentRhs: rhs).map(Self.userNotice) },
    "USERSTATE": { lhs, rhs in UserState(contentLhs: lhs, contentRhs: rhs).map(Self.userState) },
    "CAP": { _, rhs in Capabilities(contentRhs: rhs).map(Self.capabilities) },
    "WHISPER": { lhs, rhs in Whisper(contentLhs: lhs, contentRhs: rhs).map(Self.whisper) },
    "RECONNECT": { _, _ in .reconnect },
  ]
}

extension IncomingMessage: Sendable {}
