/// A recoverable payload issue, unsupported command, or fatal line-decoding problem.
public enum ParsingDiagnostic: Sendable, Equatable {
  case malformedMessage(reason: String)
  case unsupportedCommand(command: String)
  case missingTag(name: String)
  case invalidTagValue(name: String, value: String, expectedType: String)
  /// A tag not consumed by the typed payload decoder. This is not a parsing failure.
  case unusedTag(name: String, value: String?)

  public enum Severity: Sendable, Equatable {
    case information
    case warning
    case error
  }

  public var severity: Severity {
    switch self {
    case .unsupportedCommand, .unusedTag: return .information
    case .missingTag, .invalidTagValue: return .warning
    case .malformedMessage: return .error
    }
  }
}
