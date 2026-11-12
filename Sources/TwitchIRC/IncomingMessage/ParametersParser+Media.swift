extension ParametersParser {
  mutating func emotes(for key: String = "emotes", in message: String) -> [Emote] {
    let value = string(for: key)
    var result: [Emote] = []
    for group in value.split(separator: "/", omittingEmptySubsequences: false) where !value.isEmpty
    {
      let parts = group.split(separator: ":", omittingEmptySubsequences: false)
      guard parts.count == 2, !parts[0].isEmpty else {
        recordInvalid(key: key, value: String(group), expectedType: "emote ID and ranges")
        continue
      }
      for occurrence in parts[1].split(separator: ",", omittingEmptySubsequences: false) {
        guard let range = MessageTextRange(wireValue: occurrence),
          let name = range.text(in: message)
        else {
          recordInvalid(key: key, value: String(occurrence), expectedType: "in-bounds scalar range")
          continue
        }
        result.append(Emote(id: String(parts[0]), name: name, range: range))
      }
    }
    return result
  }

  mutating func gifs(in message: String) -> [Gif] {
    let value = string(for: "gifs")
    var result: [Gif] = []
    for entry in value.split(separator: ",", omittingEmptySubsequences: false) where !value.isEmpty
    {
      let parts = entry.split(separator: "|", maxSplits: 2, omittingEmptySubsequences: false)
      guard parts.count == 3, !parts[1].isEmpty, !parts[2].isEmpty,
        let range = MessageTextRange(wireValue: parts[0]), let text = range.text(in: message)
      else {
        recordInvalid(key: "gifs", value: String(entry), expectedType: "GIF range, ID and URL")
        continue
      }
      result.append(Gif(id: String(parts[1]), url: String(parts[2]), text: text, range: range))
    }
    return result
  }
}
