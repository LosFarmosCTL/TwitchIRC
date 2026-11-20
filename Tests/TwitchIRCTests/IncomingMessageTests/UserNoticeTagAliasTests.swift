import Testing
import TwitchIRC

struct UserNoticeTagAliasTests {
  @Test(arguments: [
    (#"msg-param-recipient-name=fallback\sname"#, "fallback name"),
    (
      #"msg-param-recipient-name=fallback;msg-param-recipient-user-name=primary\sname"#,
      "primary name"
    ),
    ("msg-param-recipient-name=fallback;msg-param-recipient-user-name=", ""),
  ])
  func giftRecipientName(tags: String, expectedName: String) {
    let line = "@msg-id=subgift;\(tags) :tmi.twitch.tv USERNOTICE #foo"
    guard case .userNotice(let notice)? = IncomingMessage.parse(ircOutput: line).first?.message,
      case .subGift(let gift) = notice.kind
    else {
      Issue.record("Expected a subgift USERNOTICE")
      return
    }

    #expect(gift.recipientUserName == expectedName)
    #expect(
      notice.parsingLeftovers.unavailableKeys.contains("msg-param-recipient-user-name") == false)
  }

  @Test(arguments: ["Prime", "prime"])
  func primePlan(tagValue: String) {
    let line = "@msg-id=resub;msg-param-sub-plan=\(tagValue) :tmi.twitch.tv USERNOTICE #foo"
    guard case .userNotice(let notice)? = IncomingMessage.parse(ircOutput: line).first?.message,
      case .resub(let subscription) = notice.kind
    else {
      Issue.record("Expected a resub USERNOTICE")
      return
    }

    #expect(subscription.subPlan?.rawValue == "Prime")
    #expect(notice.parsingLeftovers.unparsedKeys.isEmpty)
    #expect(UserNotice.Kind.SubPlan(rawValue: "prime") == nil)
  }

  @Test
  func invalidPlanRetainsRawTagValue() throws {
    let line = #"@msg-id=resub;msg-param-sub-plan=unknown\splan :tmi.twitch.tv USERNOTICE #foo"#
    guard case .userNotice(let notice)? = IncomingMessage.parse(ircOutput: line).first?.message,
      case .resub(let subscription) = notice.kind
    else {
      Issue.record("Expected a resub USERNOTICE")
      return
    }

    #expect(subscription.subPlan == nil)
    let invalidTag = try #require(notice.parsingLeftovers.unparsedKeys.first)
    #expect(invalidTag.key == "msg-param-sub-plan")
    #expect(invalidTag.value == #"unknown\splan"#)
    #expect(invalidTag.type == "SubPlan")
  }
}
