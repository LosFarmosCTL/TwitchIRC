/// Decodes one IRCv3 tag value after the wire tags have been separated.
/// A single pass preserves escaped backslashes without interpreting the result again.
enum IRCMessageTagValue {
  static func decode(_ value: String) -> String {
    var result = String.UnicodeScalarView()
    var escaped = false
    for scalar in value.unicodeScalars {
      if escaped {
        switch scalar {
        case ":": result.append(";")
        case "s": result.append(" ")
        case "r": result.append("\r")
        case "n": result.append("\n")
        default: result.append(scalar)
        }
        escaped = false
      } else if scalar == "\\" {
        escaped = true
      } else {
        result.append(scalar)
      }
    }
    return String(result)
  }
}
