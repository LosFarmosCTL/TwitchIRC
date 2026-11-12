/// An inline GIF occurrence in message text.
public struct GIF: Sendable, Hashable {
  /// The identifier supplied in the IRC `gifs` tag.
  public let id: String
  /// The original URL supplied in the IRC `gifs` tag.
  public let url: String
  /// The text covered by this GIF occurrence in the enclosing message.
  public let text: String
  /// The range from the IRC `gifs` tag, converted to half-open scalar offsets in message text.
  public let range: MessageTextRange

  public init(id: String, url: String, text: String, range: MessageTextRange) {
    self.id = id
    self.url = url
    self.text = text
    self.range = range
  }
}
