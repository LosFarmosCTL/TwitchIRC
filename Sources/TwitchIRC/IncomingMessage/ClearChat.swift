
/// A Twitch `CLEARCHAT` message.
public struct ClearChat {
    
    /// Channel's name with no uppercased/Han characters.
    public var channel = String()
    /// The cleared user's name, with no uppercased/Han characters.
    /// If `nil` then the whole chat has been cleared.
    public var userLogin = Optional<String>.none
    /// The duration of the ban/timeout.
    /// If `nil` and `user` available, then the user is permanently banned.
    public var banDuration = Optional<UInt>.none
    /// Broadcaster's Twitch identifier, when supplied.
    public var roomId: String?
    /// The cleared user's Twitch identifier, when supplied.
    public var targetUserId: String?
    /// Timestamp in milliseconds since the Unix epoch, when supplied.
    public var tmiSentTs: UInt?
    
    // MARK: Convenience stuff
    public var userIsPermanentlyBanned: Bool {
        banDuration == nil && userLogin != nil
    }
    
    public init() { }
    
    init? (contentLhs: String, contentRhs: String) {
        guard contentRhs.first == "#" else {
            return nil
        } /// check for "#" behind channel name
        
        if let (channel, user) = contentRhs.dropFirst().componentsOneSplit(separatedBy: " :") {
            self.channel = String(channel)
            self.userLogin = String(user)
        } else { /// the whole chat has been cleared therefore there is no " :" to specify the user.
            self.channel = String(contentRhs.dropFirst())
        }
        
        if contentLhs.hasPrefix("@") {
            var parser = ParametersParser(String(contentLhs.dropFirst().dropLast(2)))
            self.banDuration = parser.optionalUInt(for: "ban-duration")
            self.roomId = parser.optionalString(for: "room-id")
            self.targetUserId = parser.optionalString(for: "target-user-id")
            self.tmiSentTs = parser.optionalUInt(for: "tmi-sent-ts")
        }
    }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
extension ClearChat: Sendable { }
#endif
