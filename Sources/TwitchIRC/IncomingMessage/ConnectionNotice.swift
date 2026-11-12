/// A notice of connection to Twitch.
public struct ConnectionNotice {

  /// The Twitch message accompanying the notice.
  public private(set) var message = String()
  /// The user that has been successfully connected. All lowercased.
  public private(set) var userLogin = String()
  /// The number that Twitch sends alongside this notice.
  public private(set) var number = UInt()

  internal init() {}

  init?(id: String, contentRhs: String) {
    guard let number = UInt(id),
      let (userLogin, message) = contentRhs.componentsOneSplit(separatedBy: " :")
    else { return nil }

    self.message = message
    self.userLogin = userLogin
    self.number = number
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    message: String,
    userLogin: String,
    number: UInt
  ) {
    self.message = message
    self.userLogin = userLogin
    self.number = number
  }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
  extension ConnectionNotice: Sendable {}
#endif
