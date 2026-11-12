/// A nonempty, half-open range of Unicode scalar offsets in the enclosing message's text.
/// Use only with the original text; modifying text can invalidate its offsets and indices.
public struct MessageTextRange: Sendable, Hashable {
  public let unicodeScalarOffsets: Range<Int>

  public init?(unicodeScalarOffsets: Range<Int>) {
    guard unicodeScalarOffsets.lowerBound >= 0, !unicodeScalarOffsets.isEmpty else { return nil }
    self.unicodeScalarOffsets = unicodeScalarOffsets
  }

  /// Extracts scalars, including ranges whose boundaries fall inside a composed character.
  public func text(in message: String) -> String? {
    guard let range = scalarRange(in: message) else { return nil }
    return String(message.unicodeScalars[range])
  }

  /// Returns nil for out-of-bounds offsets or boundaries inside a composed character.
  public func stringRange(in message: String) -> Range<String.Index>? {
    guard let range = scalarRange(in: message),
      let start = range.lowerBound.samePosition(in: message),
      let end = range.upperBound.samePosition(in: message)
    else { return nil }
    return start..<end
  }

  private func scalarRange(in message: String) -> Range<String.Index>? {
    let scalars = message.unicodeScalars
    guard
      let start = scalars.index(
        scalars.startIndex, offsetBy: unicodeScalarOffsets.lowerBound, limitedBy: scalars.endIndex),
      let end = scalars.index(
        start, offsetBy: unicodeScalarOffsets.count, limitedBy: scalars.endIndex)
    else { return nil }
    return start..<end
  }

  init?(wireValue: Substring) {
    let bounds = wireValue.split(separator: "-", omittingEmptySubsequences: false)
    guard bounds.count == 2, let start = Int(bounds[0]), let end = Int(bounds[1]),
      start >= 0, end >= start, end < Int.max
    else { return nil }
    self.init(unicodeScalarOffsets: start..<(end + 1))
  }
}

struct MessageText {
  let text: String
  let isAction: Bool

  init(_ content: String) {
    isAction = content.hasPrefix("\u{1}ACTION ") && content.hasSuffix("\u{1}")
    text = isAction ? String(content.unicodeScalars.dropFirst(8).dropLast()) : content
  }
}
