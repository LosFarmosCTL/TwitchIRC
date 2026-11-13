extension IncomingMessage {
  /// Parses complete IRC lines, retaining original text, raw envelopes and decoding diagnostics.
  public static func parse(ircOutput: String) -> [MessageParseResult] {
    ircOutput.componentsSeparatedBy(separator: "\r\n")
      .filter { !$0.isEmpty }
      .map(parseLine)
  }

  private static func parseLine(_ text: String) -> MessageParseResult {
    guard let original = RawIRCMessage(line: text) else {
      return MessageParseResult(
        text: text, rawMessage: nil, outcome: .malformed,
        diagnostics: [.malformedMessage(reason: "Invalid IRC envelope")])
    }
    let raw: RawIRCMessage
    if original.prefix == nil, !supportedCommands.contains(original.command.uppercased()),
      let recovered = RawIRCMessage.recoveringTwitchTags(line: text),
      supportedCommands.contains(recovered.command.uppercased())
    {
      raw = recovered
    } else {
      raw = original
    }
    let command = raw.command.uppercased()
    guard supportedCommands.contains(command) else {
      return MessageParseResult(
        text: text, rawMessage: raw, outcome: .unsupported,
        diagnostics: [.unsupportedCommand(command: raw.command)])
    }
    guard let message = parsePayload(raw, command: command) else {
      return MessageParseResult(
        text: text, rawMessage: raw, outcome: .malformed,
        diagnostics: [.malformedMessage(reason: "Invalid payload for \(raw.command)")])
    }
    let spacedTags = raw.tags.filter { $0.value?.contains(" ") == true }
      .map {
        ParsingDiagnostic.invalidTagValue(
          name: $0.name, value: $0.value ?? "", expectedType: "IRC tag value with escaped spaces")
      }
    let diagnostics = payloadDiagnostics(message, raw: raw) + spacedTags
    return MessageParseResult(
      text: text, rawMessage: raw, outcome: .parsed(message), diagnostics: diagnostics)
  }

  private static func parsePayload(_ raw: RawIRCMessage, command: String) -> Self? {
    if command == "PING" || command == "PONG" {
      guard raw.parameters.count == 1, raw.parameters.first?.isEmpty == false else { return nil }
      return command == "PING" ? .ping : .pong
    }
    if command == "CAP" {
      return Capabilities(parameters: raw.parameters).map(Self.capabilities)
    }
    guard raw.prefix != nil else { return nil }
    if let parser = commandParsers[command] {
      return parser(raw.payloadPrefix, raw.parameterText)
    }
    return parseNumericReply(command, contentRhs: raw.parameterText)
  }

  private static func payloadDiagnostics(_ message: Self, raw: RawIRCMessage) -> [ParsingDiagnostic]
  {
    guard let leftovers = message.parsingLeftovers else {
      return raw.tags.map { .unusedTag(name: $0.name, value: $0.value) }
    }
    let valuelessTags = raw.tags.filter { $0.value == nil }
      .map { ParsingDiagnostic.unusedTag(name: $0.name, value: nil) }
    return leftovers.diagnostics + valuelessTags
  }

  private static let supportedCommands: Set<String> = Set(commandParsers.keys).union([
    "PING", "PONG", "CAP", "001", "002", "003", "004", "372", "375", "376", "353", "366", "421",
  ])

  private static func parseNumericReply(_ identifier: String, contentRhs: String) -> Self? {
    switch identifier {
    case "001", "002", "003", "004", "372", "375", "376":
      return ConnectionNotice(id: identifier, contentRhs: contentRhs).map(Self.connectionNotice)
    case "353", "366":
      return ChannelEntrance(id: identifier, contentRhs: contentRhs).map(Self.channelEntrance)
    case "421":
      return UnknownCommand(contentRhs: contentRhs).map(Self.unknownCommand)
    default: return nil
    }
  }

  private static let commandParsers: [String: @Sendable (String, String) -> Self?] = [
    "GLOBALUSERSTATE": { lhs, _ in .globalUserState(GlobalUserState(contentLhs: lhs)) },
    "PRIVMSG": { lhs, rhs in
      PrivateMessage(contentLhs: lhs, contentRhs: rhs).map(Self.privateMessage)
    },
    "JOIN": { lhs, rhs in Join(contentLhs: lhs, contentRhs: rhs).map(Self.join) },
    "PART": { lhs, rhs in Part(contentLhs: lhs, contentRhs: rhs).map(Self.part) },
    "CLEARCHAT": { lhs, rhs in ClearChat(contentLhs: lhs, contentRhs: rhs).map(Self.clearChat) },
    "CLEARMSG": { lhs, rhs in ClearMessage(contentLhs: lhs, contentRhs: rhs).map(Self.clearMessage)
    },
    "HOSTTARGET": { _, rhs in HostTarget(contentRhs: rhs).map(Self.hostTarget) },
    "NOTICE": { lhs, rhs in Notice(contentLhs: lhs, contentRhs: rhs).map(Self.notice) },
    "ROOMSTATE": { lhs, rhs in RoomState(contentLhs: lhs, contentRhs: rhs).map(Self.roomState) },
    "USERNOTICE": { lhs, rhs in UserNotice(contentLhs: lhs, contentRhs: rhs).map(Self.userNotice) },
    "USERSTATE": { lhs, rhs in UserState(contentLhs: lhs, contentRhs: rhs).map(Self.userState) },
    "WHISPER": { lhs, rhs in Whisper(contentLhs: lhs, contentRhs: rhs).map(Self.whisper) },
    "RECONNECT": { _, _ in .reconnect },
  ]
}
