/// An inline GIF occurrence in message text.
public struct Gif: Sendable, Hashable {
  public let id: String
  public let url: String
  public let text: String
  public let range: MessageTextRange

  public init(id: String, url: String, text: String, range: MessageTextRange) {
    self.id = id
    self.url = url
    self.text = text
    self.range = range
  }
}
