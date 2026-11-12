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
      /// The notice's identifier.
      messageId: MessageID
    )
    /// A channel notice with an unrecognized identifier.
    case unknownLocal(
      /// The channel's lowercased name.
      channel: String,
      /// The notice's message.
      message: String,
      /// The notice's identifier exactly as received, without normalization.
      messageId: String
    )
  }

  /// The notice's kind. Also contains the related info.
  public var kind: Kind!
  /// The local notice identifier exactly as received, including underscores.
  public var rawMessageId: String?
  /// Timestamp in milliseconds since the Unix epoch, when supplied.
  public var tmiSentTs: UInt?

  public init() {}

  init?(contentLhs: String, contentRhs: String) {
    if contentLhs.hasPrefix("@"),
      contentRhs.first == "#",
      let (channel, message) = contentRhs.dropFirst().componentsOneSplit(separatedBy: " :")
    {
      var parser = ParametersParser(String(contentLhs.dropFirst().dropLast(2)))
      guard let messageIdValue = parser.optionalString(for: "msg-id"),
        !messageIdValue.isEmpty
      else {
        return nil
      }
      self.rawMessageId = messageIdValue
      self.tmiSentTs = parser.optionalUInt(for: "tmi-sent-ts")
      if let messageId = MessageID(rawValue: messageIdValue) {
        self.kind = .local(
          channel: String(channel),
          message: String(message),
          messageId: messageId
        )
      } else {
        self.kind = .unknownLocal(
          channel: String(channel),
          message: String(message),
          messageId: messageIdValue
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
}

// MARK: - Sendable conformances
#if swift(>=5.5)
  extension Notice: Sendable {}
  extension Notice.Kind: Sendable {}
#endif
