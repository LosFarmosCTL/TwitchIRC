/// A Twitch `NOTICE` message.
public struct Notice {

  public enum Kind {
    case global(
      /// The notice's message.
      message: String
    )
    case local(
      /// The channel's lowercased name.
      channel: String,
      /// The notice's message.
      message: String,
      /// The recognized notice code from the IRC `msg-id` tag.
      code: Code
    )
    /// A channel notice with an unrecognized identifier.
    case unknownLocal(
      /// The channel's lowercased name.
      channel: String,
      /// The notice's message.
      message: String,
      /// The IRC `msg-id` tag exactly as received, without normalization.
      code: String
    )
  }

  /// The notice's kind. Also contains the related info.
  public private(set) var kind: Kind
  /// The local notice identifier exactly as received, including underscores.
  /// IRC tag: `msg-id`.
  public private(set) var rawCode: String?
  /// The server timestamp, in milliseconds since the Unix epoch; nil when absent.
  /// IRC tag: `tmi-sent-ts`.
  public private(set) var timestampMilliseconds: UInt?

  /// Unconsumed tags and recoverable field-decoding issues.
  public private(set) var parsingLeftovers = ParsingLeftovers()

  init?(contentLhs: String, contentRhs: String) {
    if contentLhs.hasPrefix("@"),
      contentRhs.first == "#",
      let (channel, message) = contentRhs.dropFirst().componentsOneSplit(separatedBy: " :")
    {
      var parser = ParametersParser(String(contentLhs.dropFirst().dropLast(2)))
      guard let messageIDValue = parser.optionalString(for: "msg-id"),
        !messageIDValue.isEmpty
      else {
        return nil
      }
      self.rawCode = messageIDValue
      self.timestampMilliseconds = parser.optionalUInt(for: "tmi-sent-ts")
      self.parsingLeftovers = parser.getLeftOvers(excludedUnavailableKeys: ["tmi-sent-ts"])
      if let code = Code(rawValue: messageIDValue) {
        self.kind = .local(
          channel: String(channel),
          message: String(message),
          code: code
        )
      } else {
        self.kind = .unknownLocal(
          channel: String(channel),
          message: String(message),
          code: messageIDValue
        )
      }
    } else if let (star, message) = contentRhs.componentsOneSplit(separatedBy: " :"),
      star == "*"
    {
      self.kind = .global(message: message)
    } else {
      return nil
    }
  }
  /// Creates a message from its required fields and optional metadata.
  public init(
    kind: Kind,
    rawCode: String? = nil,
    timestampMilliseconds: UInt? = nil,
    parsingLeftovers: ParsingLeftovers = ParsingLeftovers()
  ) {
    self.kind = kind
    self.rawCode = rawCode
    self.timestampMilliseconds = timestampMilliseconds
    self.parsingLeftovers = parsingLeftovers
  }
}

// MARK: - Sendable conformances
#if swift(>=5.5)
  extension Notice: Sendable {}
  extension Notice.Kind: Sendable {}
#endif
