/// A Twitch IRC `CAP` response acknowledging or rejecting capability requests.
public struct Capabilities: Sendable {
  /// The IRC `CAP` subcommand describing the result of a capability request.
  public enum Response: String, Sendable {
    /// The server accepted the capabilities (`ACK`).
    case acknowledged = "ACK"
    /// The server rejected the capabilities (`NAK`).
    case rejected = "NAK"
  }

  /// Whether the server accepted or rejected this request (`CAP ACK` / `CAP NAK`).
  public let response: Response
  /// Recognized capabilities in the response; these are not necessarily accepted.
  /// Inspect `response` before treating them as enabled.
  public let capabilities: [Capability]
  /// All capability names from the IRC `CAP` trailing parameter, including unknown names.
  /// Their order and spelling are preserved.
  public let rawCapabilities: [String]

  init?(parameters: [String]) {
    guard parameters.count == 3, !parameters[0].isEmpty,
      let response = Response(rawValue: parameters[1])
    else { return nil }
    let names = parameters[2].split(separator: " ").map(String.init)
    guard !names.isEmpty else { return nil }
    self.init(response: response, rawCapabilities: names)
  }

  /// Creates a response for recognized capabilities; defaults to `ACK`.
  public init(response: Response = .acknowledged, capabilities: [Capability]) {
    self.init(response: response, rawCapabilities: capabilities.map(\.twitchDescription))
  }

  /// Creates a response without discarding unfamiliar capability names.
  public init(response: Response, rawCapabilities: [String]) {
    self.response = response
    self.rawCapabilities = rawCapabilities
    self.capabilities = rawCapabilities.compactMap { name in
      Capability.allCases.first { $0.twitchDescription == name }
    }
  }
}
