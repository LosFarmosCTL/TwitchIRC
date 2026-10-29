@testable import TwitchIRC
import XCTest

final class ClearChatTests: XCTestCase {

    func testTaggedTimeoutPreservesIdentityAndTimestamp() throws {
        let cc: ClearChat = try TestUtils.parseAndUnwrap(
            string: "@room-id=324;target-user-id=42;tmi-sent-ts=1700000000000;ban-duration=60 :tmi.twitch.tv CLEARCHAT #dallas :ronni"
        )
        XCTAssertEqual(cc.banDuration, 60)
        XCTAssertEqual(cc.roomId, "324")
        XCTAssertEqual(cc.targetUserId, "42")
        XCTAssertEqual(cc.tmiSentTs, 1700000000000)
    }
    
    func testParsedValues1() throws {
        let string = ":tmi.twitch.tv CLEARCHAT #dallas"
        let cc: ClearChat = try TestUtils.parseAndUnwrap(string: string)
        
        XCTAssertEqual(cc.channel, "dallas")
        XCTAssertEqual(cc.userLogin, nil)
        XCTAssertEqual(cc.banDuration, nil)
        XCTAssertEqual(cc.userIsPermanentlyBanned, false)
    }
    
    func testParsedValues2() throws {
        let string = ":tmi.twitch.tv CLEARCHAT #dallas :ronni"
        let cc: ClearChat = try TestUtils.parseAndUnwrap(string: string)
        
        XCTAssertEqual(cc.channel, "dallas")
        XCTAssertEqual(cc.userLogin, "ronni")
        XCTAssertEqual(cc.banDuration, nil)
        XCTAssertEqual(cc.userIsPermanentlyBanned, true)
    }
    
    func testParsedValues3() throws {
        let string = "@ban-duration=3600 :tmi.twitch.tv CLEARCHAT #goodvibes :toxicity"
        let cc: ClearChat = try TestUtils.parseAndUnwrap(string: string)
        
        XCTAssertEqual(cc.channel, "goodvibes")
        XCTAssertEqual(cc.userLogin, "toxicity")
        XCTAssertEqual(cc.banDuration, 3600)
        XCTAssertEqual(cc.userIsPermanentlyBanned, false)
    }
}
