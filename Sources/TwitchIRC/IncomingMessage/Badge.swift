/// A badge set and its version, used to select a Twitch badge asset.
public struct Badge: Sendable, Hashable {
  public let setID: String
  public let version: String

  public init(setID: String, version: String) {
    self.setID = setID
    self.version = version
  }
}

/// Additional metadata for a badge set, not its asset version.
/// For subscribers, the value describes subscription tenure.
public struct BadgeInfo: Sendable, Hashable {
  public let setID: String
  public let value: String

  public init(setID: String, value: String) {
    self.setID = setID
    self.value = value
  }
}
