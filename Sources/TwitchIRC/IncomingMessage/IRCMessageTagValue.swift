/// Encodes and decodes IRCv3 tag values, independently of message bodies.
enum IRCMessageTagValue {
  static func encode(_ value: String) -> String {
    var result = ""
    for scalar in value.unicodeScalars {
      switch scalar {
      case ";": result += "\\:"
      case " ": result += "\\s"
      case "\\": result += "\\\\"
      case "\r": result += "\\r"
      case "\n": result += "\\n"
      default: result.unicodeScalars.append(scalar)
      }
    }
    return result
  }

  /// A single pass preserves escaped backslashes without interpreting the result again.
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
