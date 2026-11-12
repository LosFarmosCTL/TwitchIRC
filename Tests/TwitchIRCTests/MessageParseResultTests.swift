import TwitchIRC
import XCTest

final class MessageParseResultTests: XCTestCase {
  func testUnsupportedCommandPreservesItsEnvelope() throws {
    let line = #"@future=some\svalue;flag :server.example FUTURE #channel :Hello world"#
    let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
    guard case .unsupported = result.outcome else { return XCTFail("Expected unsupported command") }
    XCTAssertNil(result.message)
    XCTAssertEqual(result.text, line)
    let raw = try XCTUnwrap(result.rawMessage)
    XCTAssertEqual(raw.prefix, "server.example")
    XCTAssertEqual(raw.command, "FUTURE")
    XCTAssertEqual(raw.parameters, ["#channel", "Hello world"])
    XCTAssertEqual(raw.tags.map(\.name), ["future", "flag"])
    XCTAssertEqual(raw.tags.map(\.value), [#"some\svalue"#, nil])
    XCTAssertEqual(result.diagnostics, [.unsupportedCommand(command: "FUTURE")])
    XCTAssertEqual(result.diagnostics.first?.severity, .information)
  }

  func testMalformedKnownPayloadStillPreservesEnvelope() throws {
    let line = "@future=kept :tmi.twitch.tv USERNOTICE not-a-channel :Hello"
    let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
    guard case .malformed = result.outcome else { return XCTFail("Expected malformed payload") }
    XCTAssertNil(result.message)
    XCTAssertEqual(result.text, line)
    XCTAssertEqual(result.rawMessage?.command, "USERNOTICE")
    XCTAssertEqual(result.rawMessage?.tags.first?.value, "kept")
    XCTAssertEqual(result.diagnostics.first?.severity, .error)
  }

  func testBatchKeepsFailuresAndFollowingMessagesInOrder() {
    let lines = ["PING :token", "@id=missing-command", ":server FUTURE :Hello"]
    let results = IncomingMessage.parse(
      ircOutput: "\r\n" + lines.joined(separator: "\r\n") + "\r\n")
    XCTAssertEqual(results.map(\.text), lines)
    guard results.count == 3,
      case .parsed(.ping) = results[0].outcome,
      case .malformed = results[1].outcome,
      case .unsupported = results[2].outcome
    else { return XCTFail("Expected parsed, malformed and unsupported results") }
    XCTAssertEqual(results[0].rawMessage?.parameters, ["token"])
    XCTAssertNil(results[1].rawMessage)
    XCTAssertEqual(results[1].diagnostics.first?.severity, .error)
  }

  func testUnusedTagsAreInformationalAndInvalidValuesAreWarnings() throws {
    let result = try parseChat(extraTags: #"first-msg=invalid;future=some\svalue;flag"#)
    guard case .parsed(.privateMessage(let message)) = result.outcome else {
      return XCTFail("Expected a recoverable typed message")
    }
    XCTAssertNil(message.firstMessage)
    let invalid = ParsingDiagnostic.invalidTagValue(
      name: "first-msg", value: "invalid", expectedType: "Bool")
    let unused = ParsingDiagnostic.unusedTag(name: "future", value: #"some\svalue"#)
    XCTAssertTrue(result.diagnostics.contains(invalid))
    XCTAssertTrue(result.diagnostics.contains(unused))
    XCTAssertTrue(result.diagnostics.contains(.unusedTag(name: "flag", value: nil)))
    XCTAssertEqual(invalid.severity, .warning)
    XCTAssertEqual(unused.severity, .information)
  }

  func testMissingTagsProduceStructuredDiagnostics() throws {
    let result = try parseChat(extraTags: "", omitDisplayName: true)
    guard case .parsed = result.outcome else { return XCTFail("Expected a recoverable message") }
    XCTAssertTrue(result.diagnostics.contains(.missingTag(name: "display-name")))
    XCTAssertEqual(ParsingDiagnostic.missingTag(name: "display-name").severity, .warning)
  }

  func testHostnameInsideTagDoesNotCorruptCommandParsing() throws {
    let result = try parseChat(extraTags: "future=tmi.twitch.tv")
    guard case .privateMessage(let message)? = result.message else {
      return XCTFail("Expected a chat message")
    }
    XCTAssertEqual(message.id, "message")
    XCTAssertEqual(message.message, "Hello")
    XCTAssertEqual(result.rawMessage?.command, "PRIVMSG")
  }

  func testMalformedClearChatTagsAreReported() throws {
    let line = "@ban-duration=invalid :tmi.twitch.tv CLEARCHAT #channel :viewer"
    let result = try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
    guard case .parsed(.clearChat) = result.outcome else {
      return XCTFail("Expected a clear-chat message")
    }
    XCTAssertTrue(
      result.diagnostics.contains(
        .invalidTagValue(name: "ban-duration", value: "invalid", expectedType: "UInt")))
  }

  private func parseChat(extraTags: String, omitDisplayName: Bool = false) throws
    -> MessageParseResult
  {
    let common = "@badge-info=;badges=;color=;emotes=;flags=;id=message;room-id=room;user-id=user"
    let displayName = omitDisplayName ? "" : ";display-name=Viewer"
    let tags = extraTags.isEmpty ? "" : ";\(extraTags)"
    let line =
      "\(common)\(displayName)\(tags) :viewer!viewer@viewer.tmi.twitch.tv PRIVMSG #channel :Hello"
    return try XCTUnwrap(IncomingMessage.parse(ircOutput: line).first)
  }
}
