extension UserNotice.Kind {
  public struct RaidInfo: Sendable {
    /// IRC tag: `msg-param-displayName`.
    public private(set) var displayName: String
    /// IRC tag: `msg-param-login`.
    public private(set) var login: String
    /// IRC tag: `msg-param-viewerCount`.
    public private(set) var viewerCount: UInt
    /// IRC tag: `msg-param-profileImageURL`.
    public private(set) var profileImageURL: String

    public init(
      displayName: String,
      login: String,
      viewerCount: UInt,
      profileImageURL: String
    ) {
      self.displayName = displayName
      self.login = login
      self.viewerCount = viewerCount
      self.profileImageURL = profileImageURL
    }

    internal init() {
      self.init(
        displayName: String(),
        login: String(),
        viewerCount: UInt(),
        profileImageURL: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        displayName: parser.string(for: "msg-param-displayName"),
        login: parser.string(for: "msg-param-login"),
        viewerCount: parser.uint(for: "msg-param-viewerCount"),
        profileImageURL: parser.string(for: "msg-param-profileImageURL")
      )
    }
  }

  public struct CommunityPayForwardInfo: Sendable {
    /// IRC tag: `msg-param-prior-gifter-anonymous`.
    public private(set) var priorGifterAnonymous: Bool
    /// IRC tag: `msg-param-prior-gifter-display-name`.
    public private(set) var priorGifterDisplayName: String
    /// IRC tag: `msg-param-prior-gifter-id`.
    public private(set) var priorGifterID: String
    /// IRC tag: `msg-param-prior-gifter-user-name`.
    public private(set) var priorGifterUserName: String

    public init(
      priorGifterAnonymous: Bool,
      priorGifterDisplayName: String,
      priorGifterID: String,
      priorGifterUserName: String
    ) {
      self.priorGifterAnonymous = priorGifterAnonymous
      self.priorGifterDisplayName = priorGifterDisplayName
      self.priorGifterID = priorGifterID
      self.priorGifterUserName = priorGifterUserName
    }

    internal init() {
      self.init(
        priorGifterAnonymous: Bool(),
        priorGifterDisplayName: String(),
        priorGifterID: String(),
        priorGifterUserName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        priorGifterAnonymous: parser.bool(for: "msg-param-prior-gifter-anonymous"),
        priorGifterDisplayName: parser.string(for: "msg-param-prior-gifter-display-name"),
        priorGifterID: parser.string(for: "msg-param-prior-gifter-id"),
        priorGifterUserName: parser.string(for: "msg-param-prior-gifter-user-name")
      )
    }
  }

  public struct StandardPayForwardInfo: Sendable {
    /// IRC tag: `msg-param-prior-gifter-anonymous`.
    public private(set) var priorGifterAnonymous: Bool
    /// IRC tag: `msg-param-prior-gifter-display-name`.
    public private(set) var priorGifterDisplayName: String
    /// IRC tag: `msg-param-prior-gifter-id`.
    public private(set) var priorGifterID: String
    /// IRC tag: `msg-param-prior-gifter-user-name`.
    public private(set) var priorGifterUserName: String
    /// IRC tag: `msg-param-recipient-display-name`.
    public private(set) var recipientDisplayName: String
    /// IRC tag: `msg-param-recipient-id`.
    public private(set) var recipientID: String
    /// IRC tag: `msg-param-recipient-user-name`.
    public private(set) var recipientUserName: String

    public init(
      priorGifterAnonymous: Bool,
      priorGifterDisplayName: String,
      priorGifterID: String,
      priorGifterUserName: String,
      recipientDisplayName: String,
      recipientID: String,
      recipientUserName: String
    ) {
      self.priorGifterAnonymous = priorGifterAnonymous
      self.priorGifterDisplayName = priorGifterDisplayName
      self.priorGifterID = priorGifterID
      self.priorGifterUserName = priorGifterUserName
      self.recipientDisplayName = recipientDisplayName
      self.recipientID = recipientID
      self.recipientUserName = recipientUserName
    }

    internal init() {
      self.init(
        priorGifterAnonymous: Bool(),
        priorGifterDisplayName: String(),
        priorGifterID: String(),
        priorGifterUserName: String(),
        recipientDisplayName: String(),
        recipientID: String(),
        recipientUserName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        priorGifterAnonymous: parser.bool(for: "msg-param-prior-gifter-anonymous"),
        priorGifterDisplayName: parser.string(for: "msg-param-prior-gifter-display-name"),
        priorGifterID: parser.string(for: "msg-param-prior-gifter-id"),
        priorGifterUserName: parser.string(for: "msg-param-prior-gifter-user-name"),
        recipientDisplayName: parser.string(for: "msg-param-recipient-display-name"),
        recipientID: parser.string(for: "msg-param-recipient-id"),
        recipientUserName: parser.string(for: "msg-param-recipient-user-name")
      )
    }
  }

}

extension UserNotice.Kind.RaidInfo {
  static let optionalKeyGroups: [[String]] = [["msg-param-profileImageURL"]]
}

extension UserNotice.Kind.CommunityPayForwardInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.Kind.StandardPayForwardInfo {
  static let optionalKeyGroups: [[String]] = []
}
