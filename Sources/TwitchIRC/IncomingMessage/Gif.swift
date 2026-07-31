public struct Gif {
    /// The GIF ID.
    public var id = String()
    /// The URL used to render the GIF.
    public var url = String()
    /// The text used to represent the GIF in the message.
    public var text = String()
    /// The index in the message at which the GIF starts.
    public var startIndex = Int()
    /// The index in the message at which the GIF ends.
    public var endIndex = Int()

    public init() { }

    init(
        id: String,
        url: String,
        text: String,
        startIndex: Int,
        endIndex: Int
    ) {
        self.id = id
        self.url = url
        self.text = text
        self.startIndex = startIndex
        self.endIndex = endIndex
    }

    static func parse(from gifString: String, and message: String) -> [Gif] {
        let message = message.unicodeScalars
        var parsed = [Gif]()

        for gif in gifString.split(separator: ",") {
            let split = gif.split(
                separator: "|",
                maxSplits: 2,
                omittingEmptySubsequences: false
            )
            guard split.count == 3 else { continue }
            let range = split[0].split(separator: "-")
            guard range.count == 2,
                  let lowerBound = Int(String(range[0])),
                  let upperBound = Int(String(range[1])),
                  let text = message[stringIn: lowerBound...upperBound]
            else { continue }
            parsed.append(.init(
                id: String(split[1]),
                url: String(split[2]),
                text: text,
                startIndex: lowerBound,
                endIndex: upperBound
            ))
        }

        return parsed
    }
}

private extension String.UnicodeScalarView {
    /// Subscripts a string using integers to create the equivalent indices.
    subscript(stringIn range: ClosedRange<Int>) -> String? {
        guard let start = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
              let end = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex)
        else { return nil }

        return String(self[start...end])
    }
}

// MARK: - Sendable conformance
#if swift(>=5.5)
extension Gif: Sendable { }
#endif
