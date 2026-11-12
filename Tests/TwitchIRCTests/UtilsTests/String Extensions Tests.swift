import XCTest

@testable import TwitchIRC

final class StringExtensionTests: XCTestCase {
  private struct SplitCase {
    let name: String
    let input: String
    let separator: String
    let expected: [String]?
  }

  func testComponentsSeparatedBy() {
    for example in Self.separatedCases {
      XCTAssertEqual(
        example.input.componentsSeparatedBy(separator: example.separator), example.expected,
        example.name)
      let substring = makeSubstring(example.input)
      XCTAssertEqual(
        substring.componentsSeparatedBy(separator: example.separator).map(String.init),
        example.expected, "Substring: \(example.name)")
    }
  }

  func testComponentsOneSplit() {
    for example in Self.singleSplitCases {
      let stringResult = example.input.componentsOneSplit(separatedBy: example.separator)
      XCTAssertEqual(stringResult.map { [$0.lhs, $0.rhs] }, example.expected, example.name)
      let substringResult = makeSubstring(example.input).componentsOneSplit(
        separatedBy: example.separator)
      XCTAssertEqual(
        substringResult.map { [String($0.lhs), String($0.rhs)] }, example.expected,
        "Substring: \(example.name)")
    }
  }

  private func makeSubstring(_ string: String) -> Substring {
    let padded = "1" + string + "b"
    return padded[padded.index(after: padded.startIndex)..<padded.index(before: padded.endIndex)]
  }

  private static let separatedCases: [SplitCase] = [
    SplitCase(
      name: "normal usage", input: "Hello my dear.", separator: "my",
      expected: ["Hello ", " dear."]),
    SplitCase(
      name: "separator at the end", input: "Hello my dear.", separator: "dear.",
      expected: ["Hello my ", ""]),
    SplitCase(
      name: "separator at the beginning", input: "Hello my dear.", separator: "Hell",
      expected: ["", "o my dear."]),
    SplitCase(
      name: "only one letter", input: "Hello my dear.", separator: "m",
      expected: ["Hello ", "y dear."]),
    SplitCase(
      name: "only one letter at the end", input: "Hello my dear.", separator: ".",
      expected: ["Hello my dear", ""]),
    SplitCase(
      name: "multiple matching cases", input: "Hello my dear dear.", separator: "dear",
      expected: ["Hello my ", " ", "."]),
    SplitCase(
      name: "multiple matching cases 2", input: "dear Hello my deardear", separator: "dear",
      expected: ["", " Hello my ", "", ""]),
    SplitCase(
      name: "half-overlapping cases", input: "dedear", separator: "dear", expected: ["de", ""]),
    SplitCase(
      name: "half-overlapping cases 2", input: "uretmi.tmi.twitch.tv PRIVMSG",
      separator: "tmi.twitch.tv", expected: ["uretmi.", " PRIVMSG"]),
    SplitCase(
      name: "very similar matching cases", input: "Hello my dear dear.", separator: "dear.",
      expected: ["Hello my dear ", ""]),
    SplitCase(
      name: "a string split by itself", input: "dear", separator: "dear", expected: ["", ""]),
    SplitCase(
      name: "2x(a string) split by itself", input: "deardear", separator: "dear",
      expected: ["", "", ""]),
    SplitCase(
      name: "no matching cases", input: "Hello my dear dear.", separator: "dearr",
      expected: ["Hello my dear dear."]),
    SplitCase(
      name: "no matching cases at the end", input: "Hello my dear dear.", separator: "dear..",
      expected: ["Hello my dear dear."]),
    SplitCase(name: "empty string", input: "", separator: "dear..", expected: [""]),
    SplitCase(name: "empty separator", input: "dear..", separator: "", expected: ["dear.."]),
    SplitCase(name: "empty string and separator", input: "", separator: "", expected: [""]),
    SplitCase(name: "repeated prefix", input: "aaab", separator: "aab", expected: ["a", ""]),
    SplitCase(name: "Unicode graphemes", input: "👩🏽‍💻é👩🏽‍💻", separator: "👩🏽‍💻", expected: ["", "é", ""]),
  ]

  private static let singleSplitCases: [SplitCase] = [
    SplitCase(
      name: "normal usage", input: "Hello my dear.", separator: "my",
      expected: ["Hello ", " dear."]),
    SplitCase(
      name: "separator at the end", input: "Hello my dear.", separator: "dear.",
      expected: ["Hello my ", ""]),
    SplitCase(
      name: "separator at the beginning", input: "Hello my dear.", separator: "Hell",
      expected: ["", "o my dear."]),
    SplitCase(
      name: "only one letter", input: "Hello my dear.", separator: "m",
      expected: ["Hello ", "y dear."]),
    SplitCase(
      name: "only one letter at the end", input: "Hello my dear.", separator: ".",
      expected: ["Hello my dear", ""]),
    SplitCase(
      name: "multiple matching cases", input: "Hello my dear dear.", separator: "dear",
      expected: ["Hello my ", " dear."]),
    SplitCase(
      name: "very similar matching cases", input: "Hello my dear dear.", separator: "dear.",
      expected: ["Hello my dear ", ""]),
    SplitCase(
      name: "no matching cases", input: "Hello my dear dear.", separator: "dearr", expected: nil),
    SplitCase(
      name: "no matching cases at the end", input: "Hello my dear dear.", separator: "dear..",
      expected: nil),
    SplitCase(
      name: "a string split by itself", input: "dear", separator: "dear", expected: ["", ""]),
    SplitCase(name: "empty string", input: "", separator: "dear..", expected: nil),
    SplitCase(
      name: "half-overlapping cases", input: "uretmi.tmi.twitch.tv PRIVMSG",
      separator: "tmi.twitch.tv", expected: ["uretmi.", " PRIVMSG"]),
    SplitCase(name: "empty separator", input: "Hello", separator: "", expected: nil),
    SplitCase(name: "empty string and separator", input: "", separator: "", expected: nil),
    SplitCase(name: "repeated prefix", input: "aaab", separator: "aab", expected: ["a", ""]),
    SplitCase(name: "Unicode graphemes", input: "👩🏽‍💻é👩🏽‍💻", separator: "👩🏽‍💻", expected: ["", "é👩🏽‍💻"]),
  ]
}
