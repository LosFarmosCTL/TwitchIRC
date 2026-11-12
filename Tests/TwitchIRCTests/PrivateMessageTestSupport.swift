import XCTest

@testable import TwitchIRC

// MARK: - Emote Equatable
extension Emote: Equatable {
  public static func == (lhs: Emote, rhs: Emote) -> Bool {
    lhs.id == rhs.id
      && lhs.startIndex == rhs.startIndex
      && lhs.endIndex == rhs.endIndex
      && lhs.name == rhs.name
  }
}

// MARK: - PrivateMessage.ReplyParent Equatable (basically)
func == (lhs: PrivateMessage.ReplyParent, rhs: PrivateMessage.ReplyParent) -> Bool {
  lhs.displayName == rhs.displayName
    && lhs.userLogin == rhs.userLogin
    && lhs.message == rhs.message
    && lhs.id == rhs.id
    && lhs.userId == rhs.userId
}

// MARK: - PrivateMessage.ReplyThreadParent Equatable (basically)
func == (
  lhs: PrivateMessage.ReplyThreadParent,
  rhs: PrivateMessage.ReplyThreadParent
) -> Bool {
  lhs.userLogin == rhs.userLogin
    && lhs.messageId == rhs.messageId
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
