extension ParametersParser {
  mutating func badges(for key: String = "badges") -> [Badge] {
    badgePairs(for: key).map { Badge(setID: $0.setID, version: $0.value) }
  }

  mutating func badgeInfo(for key: String = "badge-info") -> [BadgeInfo] {
    badgePairs(for: key).map { BadgeInfo(setID: $0.setID, value: $0.value) }
  }

  private mutating func badgePairs(for key: String) -> [(setID: String, value: String)] {
    let value = string(for: key)
    var result: [(setID: String, value: String)] = []
    for entry in value.split(separator: ",", omittingEmptySubsequences: false) where !value.isEmpty
    {
      let parts = entry.split(separator: "/", maxSplits: 1, omittingEmptySubsequences: false)
      guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else {
        recordInvalid(key: key, value: String(entry), expectedType: "badge set/value pair")
        continue
      }
      result.append((setID: String(parts[0]), value: String(parts[1])))
    }
    return result
  }
}
