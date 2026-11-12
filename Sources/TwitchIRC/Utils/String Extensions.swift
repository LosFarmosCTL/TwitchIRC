extension RangeReplaceableCollection where Element == Character, Index == String.Index {

  /// Splits self by a given separator into as many pieces as possible.
  ///
  /// Not naming it `components(separatedBy:)` to make
  /// sure it's not confused with that of `Foundation`.
  func componentsSeparatedBy(separator: String) -> [Self] {
    guard !separator.isEmpty else { return [self] }
    var components = [Self]()
    var lowerBound = startIndex
    while let range = separatorRange(separator, startingAt: lowerBound) {
      components.append(Self(self[lowerBound..<range.lowerBound]))
      lowerBound = range.upperBound
    }
    components.append(Self(self[lowerBound...]))
    return components
  }

  /// Splits self into two pieces by a given separator, if the separator exists in self.
  func componentsOneSplit(separatedBy separator: String) -> (lhs: Self, rhs: Self)? {
    guard let range = separatorRange(separator, startingAt: startIndex) else { return nil }
    return (Self(self[..<range.lowerBound]), Self(self[range.upperBound...]))
  }

  /// Finds the next complete separator, including candidates after a partial match.
  private func separatorRange(_ separator: String, startingAt start: Index) -> Range<Index>? {
    guard !separator.isEmpty else { return nil }
    var candidate = start
    while candidate < endIndex {
      if self[candidate...].starts(with: separator) {
        let upperBound = index(candidate, offsetBy: separator.count)
        return candidate..<upperBound
      }
      formIndex(after: &candidate)
    }
    return nil
  }
}
