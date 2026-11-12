import XCTest

@testable import TwitchIRC

// MARK: - PrivateMessage.ReplyParent Equatable (basically)
func == (lhs: PrivateMessage.ReplyParent, rhs: PrivateMessage.ReplyParent) -> Bool {
  lhs.displayName == rhs.displayName
    && lhs.userLogin == rhs.userLogin
    && lhs.message == rhs.message
    && lhs.id == rhs.id
    && lhs.userID == rhs.userID
}

// MARK: - PrivateMessage.ReplyThreadParent Equatable (basically)
func == (
  lhs: PrivateMessage.ReplyThreadParent,
  rhs: PrivateMessage.ReplyThreadParent
) -> Bool {
  lhs.userLogin == rhs.userLogin
    && lhs.messageID == rhs.messageID
}

// MARK: - PrivateMessage.PinnedChat Equatable (basically)
func == (lhs: PrivateMessage.PinnedChat, rhs: PrivateMessage.PinnedChat) -> Bool {
  lhs.amount == rhs.amount
    && lhs.amount == rhs.amount
    && lhs.currency == rhs.currency
    && lhs.canonicalAmount == rhs.canonicalAmount
    && lhs.isSystemMessage == rhs.isSystemMessage
    && lhs.level == rhs.level
}

func expectedEmotes(_ tag: String, in text: String) -> [Emote] {
  var parser = ParametersParser("emotes=" + tag)
  return parser.emotes(in: text)
}
