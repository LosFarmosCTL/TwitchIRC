import TwitchIRC
import XCTest

final class CapabilityResponseTests: XCTestCase {
  func testRejectedUnknownCapabilitySurvivesWithOrWithoutPrefix() throws {
    for prefix in ["", ":tmi.twitch.tv "] {
      let line = prefix + "CAP * NAK :twitch.tv/unknown twitch.tv/tags"
      let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
      guard case .capabilities(let reply) = result.message else {
        return XCTFail("Expected a capability rejection")
      }
      XCTAssertEqual(reply.response, .rejected)
      XCTAssertEqual(reply.rawCapabilities, ["twitch.tv/unknown", "twitch.tv/tags"])
      XCTAssertEqual(reply.capabilities.count, 1)
      guard case .tags = reply.capabilities.first else { return XCTFail("Expected tags") }
      XCTAssertEqual(
        result.rawMessage?.parameters, ["*", "NAK", reply.rawCapabilities.joined(separator: " ")])
    }
  }

  func testAcknowledgementPreservesUnknownNamesAndNamedTarget() throws {
    let result = try XCTUnwrap(
      IncomingMessage.parse(
        ircOutput: ":tmi.twitch.tv CAP viewer ACK :future/cap twitch.tv/commands"
      ).first)
    guard case .capabilities(let reply) = result.message else {
      return XCTFail("Expected an acknowledgement")
    }
    XCTAssertEqual(reply.response, .acknowledged)
    XCTAssertEqual(reply.rawCapabilities, ["future/cap", "twitch.tv/commands"])
    XCTAssertEqual(reply.capabilities.count, 1)
  }

  func testMalformedRepliesRemainMalformed() {
    for line in [
      "CAP * NAK :", "CAP * ACK", "CAP * INVALID :twitch.tv/tags",
      "CAP * NAK :   ", "CAP * NAK extra :twitch.tv/tags",
    ] {
      guard case .malformed = IncomingMessage.parse(ircOutput: line).first?.outcome else {
        return XCTFail("Expected malformed response for \(line)")
      }
    }
  }

  func testPublicConstruction() {
    let accepted = Capabilities(capabilities: [.tags])
    XCTAssertEqual(accepted.response, .acknowledged)
    XCTAssertEqual(accepted.rawCapabilities, ["twitch.tv/tags"])
    let rejected = Capabilities(response: .rejected, rawCapabilities: ["future/cap"])
    XCTAssertEqual(rejected.response.rawValue, "NAK")
    XCTAssertTrue(rejected.capabilities.isEmpty)
    XCTAssertEqual(rejected.rawCapabilities, ["future/cap"])
  }
}
