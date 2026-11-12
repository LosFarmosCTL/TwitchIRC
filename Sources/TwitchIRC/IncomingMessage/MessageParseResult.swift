/// The result of processing one nonempty IRC line, including undecodable lines.
public struct MessageParseResult: Sendable {
  public enum Outcome: Sendable {
    case parsed(IncomingMessage)
    /// The envelope is readable, but its command has no typed decoder.
    case unsupported
    /// The envelope is invalid or a known command's payload cannot be decoded.
    case malformed
  }

  /// The original line, excluding its CRLF separator.
  public let text: String
  /// The envelope survives unsupported commands and malformed typed payloads.
  /// Nil only when the envelope itself cannot be decoded.
  public let rawMessage: RawIRCMessage?
  public let outcome: Outcome
  public let diagnostics: [ParsingDiagnostic]

  /// The typed message, if decoding succeeded. Inspect `outcome` for the reason when nil.
  public var message: IncomingMessage? {
    guard case .parsed(let message) = outcome else { return nil }
    return message
  }
}
