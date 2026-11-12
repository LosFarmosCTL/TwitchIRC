/// Notices sent after entering a channel.
public struct ChannelEntrance {

  /// The Twitch message accompanying the notice.
  public private(set) var message = String()
  /// User's name with no uppercased/Han characters.
  public private(set) var userLogin = String()
  /// The channel name that has been joined, with no uppercased/Han characters.
  public private(set) var joinedChannel = String()
  /// The number that Twitch sends alongside this notice.
  public private(set) var number = UInt()

  internal init() {}

  init?(id: String, contentRhs: String) {
    guard let number = UInt(id) else {
      return nil
    }

    self.number = number

    let separator: String
    switch number {
    case 353: separator = " = #"
    case 366: separator = " #"
    default: return nil
    }

    guard let (userLogin, rhsRemaining) = contentRhs.componentsOneSplit(separatedBy: separator),
      let (joinedChannel, message) = rhsRemaining.componentsOneSplit(separatedBy: " :")
    else { return nil }
    self.message = message
    self.userLogin = userLogin
    self.joinedChannel = joinedChannel
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    message: String,
    userLogin: String,
    joinedChannel: String,
    number: UInt
  ) {
    self.message = message
    self.userLogin = userLogin
    self.joinedChannel = joinedChannel
    self.number = number
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension ChannelEntrance: Sendable {}
#endif
