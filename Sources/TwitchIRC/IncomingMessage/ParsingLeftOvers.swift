/// The remaining stuff after parsing of messages is done.
/// Useful for making sure you've not missed any data.
/// This type should always be empty, otherwise there is a parsing problem.
/// Please report all problems on https://github.com/MahdiBM/TwitchIRC/issues.
public struct ParsingLeftOvers {

  /// A pair of key-value that was not used during parsing.
  public struct UnusedPair {
    public let key: String
    public let value: String
    public init(key: String, value: String) {
      self.key = key
      self.value = value
    }
  }

  /// An unsuccessful parsing attempt for a key
  public struct UnparsedKey {
    public let key: String
    public let value: String
    public let type: String
    public init(key: String, value: String, type: String) {
      self.key = key
      self.value = value
      self.type = type
    }
  }

  /// Key-Value pairs that were unused.
  public private(set) var unusedPairs = [UnusedPair]()
  /// Keys that were unavailable.
  public private(set) var unavailableKeys = [String]()
  /// Keys that were failed to be parsed into a certain type.
  public private(set) var unparsedKeys = [UnparsedKey]()
  public init(
    unusedPairs: [UnusedPair] = [], unavailableKeys: [String] = [], unparsedKeys: [UnparsedKey] = []
  ) {
    self.unusedPairs = unusedPairs
    self.unavailableKeys = unavailableKeys
    self.unparsedKeys = unparsedKeys
  }

  /// Whether or not there are any left overs.
  public var isEmpty: Bool {
    self.unusedPairs.isEmpty
      && self.unparsedKeys.isEmpty
      && self.unavailableKeys.isEmpty
  }
}

// MARK: - Sendable conformances
#if swift(>=5.5)
  extension ParsingLeftOvers: Sendable {}
  extension ParsingLeftOvers.UnusedPair: Sendable {}
  extension ParsingLeftOvers.UnparsedKey: Sendable {}
#endif
