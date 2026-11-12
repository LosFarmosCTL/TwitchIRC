/// A Twitch message indicating usage of an unknown command.
public struct UnknownCommand {

  /// The lowercased Twitch account username that sent the message.
  public private(set) var username = String()
  /// The command that was unknown.
  public private(set) var command = String()
  /// The Twitch message sent as an explanation.
  public private(set) var message = String()

  internal init() {}

  init?(contentRhs: String) {
    guard let (username, theRest) = contentRhs.componentsOneSplit(separatedBy: " "),
      let (command, message) = theRest.componentsOneSplit(separatedBy: " :")
    else { return nil }

    self.username = username
    self.command = command
    self.message = message
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    username: String,
    command: String,
    message: String
  ) {
    self.username = username
    self.command = command
    self.message = message
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension UnknownCommand: Sendable {}
#endif
