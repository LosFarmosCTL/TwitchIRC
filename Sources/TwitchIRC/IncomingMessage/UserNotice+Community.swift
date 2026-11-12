extension UserNotice.MessageID {
  public struct RaidInfo: Sendable {
    public var displayName: String
    public var login: String
    public var viewerCount: UInt
    public var profileImageURL: String

    internal init(
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

    public init() {
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
    public var priorGifterAnonymous: Bool
    public var priorGifterDisplayName: String
    public var priorGifterId: String
    public var priorGifterUserName: String

    internal init(
      priorGifterAnonymous: Bool,
      priorGifterDisplayName: String,
      priorGifterId: String,
      priorGifterUserName: String
    ) {
      self.priorGifterAnonymous = priorGifterAnonymous
      self.priorGifterDisplayName = priorGifterDisplayName
      self.priorGifterId = priorGifterId
      self.priorGifterUserName = priorGifterUserName
    }

    public init() {
      self.init(
        priorGifterAnonymous: Bool(),
        priorGifterDisplayName: String(),
        priorGifterId: String(),
        priorGifterUserName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        priorGifterAnonymous: parser.bool(for: "msg-param-prior-gifter-anonymous"),
        priorGifterDisplayName: parser.string(for: "msg-param-prior-gifter-display-name"),
        priorGifterId: parser.string(for: "msg-param-prior-gifter-id"),
        priorGifterUserName: parser.string(for: "msg-param-prior-gifter-user-name")
      )
    }
  }

  public struct StandardPayForwardInfo: Sendable {
    public var priorGifterAnonymous: Bool
    public var priorGifterDisplayName: String
    public var priorGifterId: String
    public var priorGifterUserName: String
    public var recipientDisplayName: String
    public var recipientId: String
    public var recipientUserName: String

    internal init(
      priorGifterAnonymous: Bool,
      priorGifterDisplayName: String,
      priorGifterId: String,
      priorGifterUserName: String,
      recipientDisplayName: String,
      recipientId: String,
      recipientUserName: String
    ) {
      self.priorGifterAnonymous = priorGifterAnonymous
      self.priorGifterDisplayName = priorGifterDisplayName
      self.priorGifterId = priorGifterId
      self.priorGifterUserName = priorGifterUserName
      self.recipientDisplayName = recipientDisplayName
      self.recipientId = recipientId
      self.recipientUserName = recipientUserName
    }

    public init() {
      self.init(
        priorGifterAnonymous: Bool(),
        priorGifterDisplayName: String(),
        priorGifterId: String(),
        priorGifterUserName: String(),
        recipientDisplayName: String(),
        recipientId: String(),
        recipientUserName: String()
      )
    }
    init(parser: inout ParametersParser) {
      self.init(
        priorGifterAnonymous: parser.bool(for: "msg-param-prior-gifter-anonymous"),
        priorGifterDisplayName: parser.string(for: "msg-param-prior-gifter-display-name"),
        priorGifterId: parser.string(for: "msg-param-prior-gifter-id"),
        priorGifterUserName: parser.string(for: "msg-param-prior-gifter-user-name"),
        recipientDisplayName: parser.string(for: "msg-param-recipient-display-name"),
        recipientId: parser.string(for: "msg-param-recipient-id"),
        recipientUserName: parser.string(for: "msg-param-recipient-user-name")
      )
    }
  }

}

extension UserNotice.MessageID.RaidInfo {
  static let optionalKeyGroups: [[String]] = [["msg-param-profileImageURL"]]
}

extension UserNotice.MessageID.CommunityPayForwardInfo {
  static let optionalKeyGroups: [[String]] = []
}

extension UserNotice.MessageID.StandardPayForwardInfo {
  static let optionalKeyGroups: [[String]] = []
}
