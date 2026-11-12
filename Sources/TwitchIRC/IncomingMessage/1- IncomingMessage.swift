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

}

extension IncomingMessage: Sendable {}
