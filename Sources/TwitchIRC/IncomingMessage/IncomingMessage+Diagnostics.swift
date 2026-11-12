extension IncomingMessage {
  var parsingLeftOvers: ParsingLeftOvers? {
    switch self {
    case .privateMessage(let message): return message.parsingLeftOvers
    case .userNotice(let message): return message.parsingLeftOvers
    case .notice(let message): return message.parsingLeftOvers
    case .clearChat(let message): return message.parsingLeftOvers
    case .clearMessage(let message): return message.parsingLeftOvers
    case .roomState(let message): return message.parsingLeftOvers
    case .globalUserState(let message): return message.parsingLeftOvers
    case .userState(let message): return message.parsingLeftOvers
    case .whisper(let message): return message.parsingLeftOvers
    default: return nil
    }
  }
}
