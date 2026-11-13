# TwitchIRC

[![CI](https://github.com/LosFarmosCTL/TwitchIRC/actions/workflows/ci.yml/badge.svg)](https://github.com/LosFarmosCTL/TwitchIRC/actions/workflows/ci.yml)

A dependency-free Swift package for parsing and serializing Twitch IRC messages.
This is a maintained fork of [MahdiBM/TwitchIRC](https://github.com/MahdiBM/TwitchIRC).
It provides message models and parsing diagnostics; your application supplies the
network connection.

Requires **Swift 6.4 or later** and uses Swift 6 language mode.

Upgrading from 1.x? Read the [2.0 migration guide](MIGRATION-2.0.md) for breaking
changes and before-and-after examples. See the [changelog](CHANGELOG.md) for release notes.

## Installation

Add this fork to your Swift package's dependencies:

```swift
.package(url: "https://github.com/LosFarmosCTL/TwitchIRC", from: "2.0.0"),
```

Then add its product to your target:

```swift
.product(name: "TwitchIRC", package: "TwitchIRC"),
```

Import the library with `import TwitchIRC`.

## Parsing messages

Pass complete IRC lines, separated by CRLF, to `IncomingMessage.parse(ircOutput:)`.
Each result contains the original line, a raw IRC envelope when readable, a typed
parsing outcome, and diagnostics.

```swift
import TwitchIRC

let input = ":viewer!viewer@viewer.tmi.twitch.tv PRIVMSG #example :Hello!\r\n"

for result in IncomingMessage.parse(ircOutput: input) {
  switch result.outcome {
  case .parsed(.privateMessage(let chat)):
    print("#\(chat.channel) \(chat.userLogin): \(chat.message)")
  case .parsed:
    break // Handle other message types here.
  case .unsupported:
    print("Unsupported command:", result.rawMessage?.command ?? "unknown")
  case .malformed:
    print("Could not decode:", result.text)
  }

  for diagnostic in result.diagnostics {
    print(diagnostic)
  }
}
```

Diagnostics include missing or invalid fields and informational unconsumed tags.
A parsed message can still have diagnostics; they do not all indicate failure.

## Message text, emotes, and badges

`PrivateMessage.message` contains displayable text. `/me` framing is removed and
represented by `isAction`. Emotes and GIFs are decoded into typed arrays whose
ranges refer to that exposed text.

Given a parsed `PrivateMessage` named `chat`:

```swift
for emote in chat.emotes {
  print(emote.id, emote.name)
  if let range = emote.range.stringRange(in: chat.message) {
    print(chat.message[range])
  }
}

for badge in chat.badges {
  print(badge.setID, badge.version)
}

if chat.isMod {
  print("Moderator or lead moderator")
}
```

Media offsets count Unicode scalars, not Swift characters or UTF-16 code units.
Use the range helpers to convert them safely. Badge asset versions and additional
`badgeInfo` metadata remain separate values.

Public field documentation names the original IRC tags, including when Swift
property names differ. Unofficial metadata can be absent or change; use optional
handling and diagnostics. Raw envelopes retain the original tags for inspection.

## Serializing messages

```swift
let outgoing = OutgoingMessage.privateMessage(
  to: "example",
  message: "Hello!"
)
let serialized = outgoing.serialize()
// Send `serialized` using your application's IRC connection.
```

## Feedback and contributions

Please open [issues](https://github.com/LosFarmosCTL/TwitchIRC/issues) and
[pull requests](https://github.com/LosFarmosCTL/TwitchIRC/pulls) against this fork.

## License

[MIT](LICENSE). Originally created by [@MahdiBM](https://github.com/MahdiBM).
This fork builds on his excellent work on the original
[TwitchIRC library](https://github.com/MahdiBM/TwitchIRC)—thank you for making it available.
