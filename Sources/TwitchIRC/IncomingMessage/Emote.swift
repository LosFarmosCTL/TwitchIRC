/// An inline Twitch emote occurrence in message text.
public struct Emote: Sendable, Hashable {
  /// The identifier supplied in the IRC `emotes` tag.
  public let id: String
  /// The text covered by this emote occurrence in the enclosing message.
  public let name: String
  /// The range from the IRC `emotes` tag, converted to half-open scalar offsets in message text.
  public let range: MessageTextRange

  public init(id: String, name: String, range: MessageTextRange) {
    self.id = id
    self.name = name
    self.range = range
  }
}
