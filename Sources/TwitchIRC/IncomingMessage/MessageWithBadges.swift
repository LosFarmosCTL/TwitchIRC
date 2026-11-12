/// Convenience protocol to add all the badge-related variables to messages.
public protocol MessageWithBadges {
  var badges: [Badge] { get }
}

extension MessageWithBadges {
  public var isMod: Bool {
    self.badges.contains { badge in
      let name = badge.setID
      return name == "moderator" || name == "lead_moderator"
    }
  }
  public var isSubscriber: Bool {
    self.badges.contains(where: { $0.setID == "subscriber" })
  }
  public var isBroadcaster: Bool {
    self.badges.contains(where: { $0.setID == "broadcaster" })
  }
  public var isVIP: Bool {
    self.badges.contains(where: { $0.setID == "vip" })
  }
  public var isTurbo: Bool {
    self.badges.contains(where: { $0.setID == "turbo" })
  }
  public var isStaff: Bool {
    self.badges.contains(where: { $0.setID == "staff" })
  }
  public var isGlobalMod: Bool {
    self.badges.contains(where: { $0.setID == "global_mod" })
  }
}
