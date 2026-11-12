/// An inline Twitch emote occurrence in message text.
public struct Emote: Sendable, Hashable {
  public let id: String
  public let name: String
  public let range: MessageTextRange

  public init(id: String, name: String, range: MessageTextRange) {
    self.id = id
    self.name = name
    self.range = range
  }
}
