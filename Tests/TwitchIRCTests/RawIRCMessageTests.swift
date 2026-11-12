import TwitchIRC
import XCTest

final class RawIRCMessageTests: XCTestCase {
  func testRawTagsAndEmptyTrailingParameterArePreserved() throws {
    let raw = try XCTUnwrap(
      RawIRCMessage(
        line:
          #"@flag;empty=;escaped=hello\sworld;duplicate=first;duplicate=second :server CMD middle :"#
      ))
    XCTAssertEqual(raw.tags.map(\.name), ["flag", "empty", "escaped", "duplicate", "duplicate"])
    XCTAssertEqual(raw.tags.map(\.value), [nil, "", #"hello\sworld"#, "first", "second"])
    XCTAssertEqual(raw.parameters, ["middle", ""])
  }

  func testTaggedMessageWithoutPrefixIsValid() throws {
    let raw = try XCTUnwrap(RawIRCMessage(line: "@label=value COMMAND #channel :Hello world"))
    XCTAssertNil(raw.prefix)
    XCTAssertEqual(raw.command, "COMMAND")
    XCTAssertEqual(raw.parameters, ["#channel", "Hello world"])
  }

  func testInvalidEnvelopesAreRejected() {
    for line in [
      "", "@tag=value", ":server", ": COMMAND", "12 #channel", "PING :one\ntwo", "PING :\0",
    ] {
      XCTAssertNil(RawIRCMessage(line: line), line)
    }
  }

  func testSpacedTagValueIsRecoveredWithWarning() throws {
    let line = "@msg-id=future;future-tag=some unescaped spaces :tmi.twitch.tv USERNOTICE #channel"
    let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
    guard case .userNotice? = result.message else { return XCTFail("Expected a recovered notice") }
    XCTAssertEqual(result.rawMessage?.tags.last?.value, "some unescaped spaces")
    XCTAssertTrue(
      result.diagnostics.contains(
        .invalidTagValue(
          name: "future-tag", value: "some unescaped spaces",
          expectedType: "IRC tag value with escaped spaces")))
  }
}
