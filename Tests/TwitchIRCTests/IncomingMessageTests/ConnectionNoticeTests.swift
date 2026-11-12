import XCTest

@testable import TwitchIRC

final class ConnectionNoticeTests: XCTestCase {

  func testParsedValues1() throws {
    let string = ":tmi.twitch.tv 001 royalealchemist :Welcome, GLHF!"
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, "Welcome, GLHF!")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 1)
  }

  func testParsedValues2() throws {
    let string = ":tmi.twitch.tv 002 royalealchemist :Your host is tmi.twitch.tv"
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, "Your host is tmi.twitch.tv")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 2)
  }

  func testParsedValues3() throws {
    let string = ":tmi.twitch.tv 003 royalealchemist :This server is rather new"
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, "This server is rather new")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 3)
  }

  func testParsedValues4() throws {
    let string = ":tmi.twitch.tv 004 royalealchemist :-"
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, "-")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 4)
  }

  func testParsedValues5() throws {
    let string = ":tmi.twitch.tv 375 royalealchemist :-"
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, "-")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 375)
  }

  func testParsedValues6() throws {
    let string =
      ":tmi.twitch.tv 372 royalealchemist :You are in a maze of twisty passages, all alike."
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, "You are in a maze of twisty passages, all alike.")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 372)
  }

  func testParsedValues7() throws {
    let string = ":tmi.twitch.tv 376 royalealchemist :>"
    let connectionNotice: ConnectionNotice = try TestUtils.parseAndUnwrap(string: string)

    XCTAssertEqual(connectionNotice.message, ">")
    XCTAssertEqual(connectionNotice.userLogin, "royalealchemist")
    XCTAssertEqual(connectionNotice.number, 376)
  }
}
