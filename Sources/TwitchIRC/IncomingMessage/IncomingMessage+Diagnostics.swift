extension IncomingMessage {
  var parsingLeftovers: ParsingLeftovers? {
    switch self {
    case .privateMessage(let message): return message.parsingLeftovers
    case .userNotice(let message): return message.parsingLeftovers
    case .notice(let message): return message.parsingLeftovers
    case .clearChat(let message): return message.parsingLeftovers
    case .clearMessage(let message): return message.parsingLeftovers
    case .roomState(let message): return message.parsingLeftovers
    case .globalUserState(let message): return message.parsingLeftovers
    case .userState(let message): return message.parsingLeftovers
    case .whisper(let message): return message.parsingLeftovers
    default: return nil
    }
  }
}
