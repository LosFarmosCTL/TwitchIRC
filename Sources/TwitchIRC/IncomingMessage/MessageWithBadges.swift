/// Convenience protocol to add all the badge-related variables to messages.
public protocol MessageWithBadges {
  var badges: [String] { get }
}

extension MessageWithBadges {
  public var isMod: Bool {
    self.badges.contains { badge in
      let name = badge.prefix { $0 != "/" }
      return name == "moderator" || name == "lead_moderator"
    }
  }
  public var isSubscriber: Bool {
    self.badges.contains(where: { $0.hasPrefix("subscriber") })
  }
  public var isBroadcaster: Bool {
    self.badges.contains(where: { $0.hasPrefix("broadcaster") })
  }
  public var isVIP: Bool {
    self.badges.contains(where: { $0.hasPrefix("vip") })
  }
  public var isTurbo: Bool {
    self.badges.contains(where: { $0.hasPrefix("turbo") })
  }
  public var isStaff: Bool {
    self.badges.contains(where: { $0.hasPrefix("staff") })
  }
  public var isGlobalMod: Bool {
    self.badges.contains(where: { $0.hasPrefix("global_mod") })
  }
}
