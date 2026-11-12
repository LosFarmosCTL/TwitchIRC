/// The IRC envelope before Twitch-specific payload decoding.
/// Tag values remain escaped exactly as sent; tag order and duplicates are preserved.
public struct RawIRCMessage: Sendable {
  /// A raw tag. A nil value means the tag had no equals sign; an empty string means `key=`.
  public struct Tag: Sendable, Equatable {
    public let name: String
    public let value: String?
  }

  public let tags: [Tag]
  public let prefix: String?
  public let command: String
  /// Parameters with the trailing parameter's colon removed, preserving its spaces and empty value.
  public let parameters: [String]
  let parameterText: String

  /// Parses one line without its terminating CRLF.
  /// Recovers spaced tag values seen in Twitch traffic; the result reports them as diagnostics.
  public init?(line: String) {
    guard
      let parsed = Self(line: line, recoverSpacedTags: false)
        ?? Self(line: line, recoverSpacedTags: true)
    else { return nil }
    self = parsed
  }

  // Used only when a readable line has no supported command and no explicit prefix.
  // A Twitch server prefix later in the line can disambiguate legacy spaced tag values.
  static func recoveringTwitchTags(line: String) -> Self? {
    guard line.hasPrefix("@"), let recovered = Self(line: line, recoverSpacedTags: true),
      recovered.prefix?.hasSuffix("tmi.twitch.tv") == true
    else { return nil }
    return recovered
  }

  private init?(line: String, recoverSpacedTags: Bool) {
    guard !line.contains("\r"), !line.contains("\n"), !line.contains("\0") else { return nil }
    var remainder = line[...]
    var tags = [Tag]()
    if remainder.first == "@" {
      let token = recoverSpacedTags ? Self.takeTagToken(&remainder) : Self.takeToken(&remainder)
      guard let token, let parsed = Self.parseTags(token.dropFirst())
      else { return nil }
      tags = parsed
    }
    var prefix: String?
    if remainder.first == ":" {
      guard let token = Self.takeToken(&remainder), token.count > 1 else { return nil }
      prefix = String(token.dropFirst())
    }
    guard let token = Self.takeToken(&remainder), Self.isCommand(token),
      let parameters = Self.parseParameters(remainder)
    else { return nil }
    self.tags = tags
    self.prefix = prefix
    self.command = String(token)
    self.parameters = parameters
    self.parameterText = String(remainder)
  }

  private static func takeTagToken(_ remainder: inout Substring) -> Substring? {
    guard let split = remainder.componentsOneSplit(separatedBy: " :") else { return nil }
    remainder = Substring(":" + split.rhs)
    return split.lhs
  }

  private static func takeToken(_ remainder: inout Substring) -> Substring? {
    remainder = remainder.drop { $0 == " " }
    guard !remainder.isEmpty else { return nil }
    let end = remainder.firstIndex(of: " ") ?? remainder.endIndex
    let token = remainder[..<end]
    remainder = remainder[end...].drop { $0 == " " }
    return token
  }

  private static func isCommand(_ token: Substring) -> Bool {
    let letters = token.utf8.allSatisfy { (65...90).contains($0) || (97...122).contains($0) }
    let numeric = token.utf8.count == 3 && token.utf8.allSatisfy { (48...57).contains($0) }
    return letters || numeric
  }

  private static func parseTags(_ token: Substring) -> [Tag]? {
    var tags = [Tag]()
    for entry in token.split(separator: ";", omittingEmptySubsequences: false) {
      let parts = entry.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
      guard let name = parts.first, !name.isEmpty else { return nil }
      tags.append(Tag(name: String(name), value: parts.count == 2 ? String(parts[1]) : nil))
    }
    return tags
  }

  private static func parseParameters(_ input: Substring) -> [String]? {
    var remainder = input
    var parameters = [String]()
    while !remainder.isEmpty {
      guard parameters.count < 15 else { return nil }
      if remainder.first == ":" {
        parameters.append(String(remainder.dropFirst()))
        break
      }
      guard let token = takeToken(&remainder) else { break }
      parameters.append(String(token))
    }
    return parameters
  }

  // Adapt the envelope to the existing payload decoders without searching tag values for a hostname.
  var payloadPrefix: String {
    let tagText =
      tags.isEmpty
      ? ""
      : "@"
        + tags.map { tag in
          tag.name + (tag.value.map { "=\($0)" } ?? "")
        }.joined(separator: ";") + " "
    guard let prefix else { return tagText }
    guard prefix.contains("!") else { return tagText + ":" }
    let suffix = "tmi.twitch.tv"
    let sender = prefix.hasSuffix(suffix) ? String(prefix.dropLast(suffix.count)) : prefix
    return tagText + ":" + sender
  }
}
