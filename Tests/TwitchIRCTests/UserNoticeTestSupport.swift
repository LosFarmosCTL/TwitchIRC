import XCTest

@testable import TwitchIRC

func unwrapInnerValue<T>(
  action: UserNotice.Kind,
  as type: T.Type = T.self,
  file: StaticString = #file,
  line: UInt = #line
) throws -> T {
  try XCTUnwrap(
    action.anyValue as? T,
    "MessageID type not expected. Available value: \(action.anyValue), Expected type: \(T.self)",
    file: file,
    line: line
  )
}

// MARK: - UserNotice.Kind anyValue
extension UserNotice.Kind {
  var anyValue: Any {
    switch self {
    case .sub(let value):
      return value
    case .resub(let value):
      return value
    case .subGift(let value):
      return value
    case .anonSubGift(let value):
      return value
    case .subMysteryGift(let value):
      return value
    case .primePaidUpgrade(let value):
      return value
    case .giftPaidUpgrade(let value):
      return value
    case .rewardGift:
      return "rewardGift"
    case .anonGiftPaidUpgrade(let value):
      return value
    case .raid(let value):
      return value
    case .unraid:
      return "unraid"
    case .ritual(let value):
      return value
    case .bitsBadgeTier(let value):
      return value
    case .communityPayForward(let value):
      return value
    case .standardPayForward(let value):
      return value
    case .announcement(let color):
      return color as Any
    case .midnightSquid(let value):
      return value
    case .charityDonation(let value):
      return value
    case .modiversary(let value):
      return value
    case .viewerMilestone(let value):
      return value
    case .unknown(let rawMessageID):
      return rawMessageID
    case .sharedChatNotice(let sourceNotice):
      return sourceNotice as Any
    }
  }
}
