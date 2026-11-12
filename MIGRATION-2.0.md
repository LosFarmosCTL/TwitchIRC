# Migrating to TwitchIRC 2.0.0

TwitchIRC 2.0 requires Swift 6.4 or later and uses Swift 6 language mode. It keeps
`import TwitchIRC`, but changes how applications consume parsing results, construct
messages, and represent missing metadata.

The changes below are ordered from those affecting the most consumer code to
more specific adjustments.

## Overview

- [Parsing results](#1-update-your-parsing-loop): replace tuple destructuring with
  `MessageParseResult`; distinguish parsed, unsupported, and malformed messages.
- [Construction and mutation](#2-update-message-construction-and-mutation): use
  explicit public initializers. Parsed properties are read-only, and required enum
  fields no longer use implicitly unwrapped optionals.
- [Message text and inline media](#message-text-and-inline-media): use normalized
  action text, typed media arrays, and Unicode scalar ranges.
- [Structured badges](#structured-badges-and-badge-metadata): read set IDs,
  asset versions, and additional metadata without splitting strings.
- [Missing metadata](#3-handle-optional-payloads-and-fields): replace empty-payload
  and default-value checks with optional handling. Preserve existing room settings
  when a partial `ROOMSTATE` update omits a field.
- [Message categories](#4-update-exhaustive-switches-and-unknown-notice-handling):
  account for new notice cases and notices that now survive typed parsing.
- [Package dependency](#5-point-your-dependency-at-the-fork): use this fork's URL
  to adopt 2.0.0.

Examples assume `import TwitchIRC`. In parsing examples, `input` is a `String`
containing one or more complete IRC lines separated by CRLF. In field-access
examples, `chat` is a parsed `PrivateMessage`.

## 1. Update your parsing loop

`IncomingMessage.parse(ircOutput:)` now returns `[MessageParseResult]`, replacing
`[(message: IncomingMessage?, text: String)]`.

**Before**

```swift
for (message, text) in IncomingMessage.parse(ircOutput: input) {
  if let message {
    // Handle the typed message.
  } else {
    print("Couldn't parse: \(text)")
    // Unsupported commands and malformed input look the same here.
  }
}
```

**After**

```swift
for result in IncomingMessage.parse(ircOutput: input) {
  if let message = result.message {
    // Handle the typed message.
  }
}
```

`result.message` remains a convenient optional view of the successfully decoded
message. `result.text` contains the original line without its CRLF separator.
Empty lines are skipped; an unsupported or malformed line still produces its own
result and does not discard subsequent lines.

### Distinguish unsupported commands from malformed input

**After**

```swift
for result in IncomingMessage.parse(ircOutput: input) {
  switch result.outcome {
  case .parsed(.privateMessage(let chat)):
    print(chat.message)

  case .parsed:
    break // Another supported message type.

  case .unsupported:
    print("Unsupported command: \(result.rawMessage?.command ?? "")")

  case .malformed:
    print("Malformed message: \(result.text)")
  }
}
```

`.unsupported` means the IRC envelope is readable but there is no typed decoder
for its command. `.malformed` means either the envelope cannot be read or a known
command's payload cannot be decoded.

### Inspect the raw envelope

For any `result` from the loop above:

```swift
if let raw = result.rawMessage {
  print(raw.command)
  print(raw.prefix ?? "")
  print(raw.parameters)

  for tag in raw.tags {
    print(tag.name, tag.value ?? "")
  }
}
```

`rawMessage` survives unsupported commands and failures to decode known payloads.
It is nil when the envelope itself cannot be decoded; the original `text` is still
retained in that case.

Raw tag values remain escaped as received. Tag order and duplicates are preserved.
A nil tag value represents a tag without `=`, while an empty string represents
`key=`. Parameters exclude the trailing parameter's leading colon, but preserve
its contents, including spaces and an empty trailing value.

### Inspect diagnostics independently of success

Previously, consumers inspected a payload's `parsingLeftOvers`, and an unconsumed
tag could be mistaken for a parsing failure. Those payload properties remain
available, but each result now exposes structured `diagnostics` as well.

For any `result`:

```swift
for diagnostic in result.diagnostics {
  switch diagnostic {
  case .unusedTag(let name, _):
    print("Informational: unconsumed tag \(name)")

  case .invalidTagValue(let name, let value, let expectedType):
    print("Warning: \(name)=\(value), expected \(expectedType)")

  default:
    print(diagnostic)
  }
}
```

| Diagnostic | Severity | Meaning |
| --- | --- | --- |
| `unusedTag` | `information` | The typed decoder did not consume a tag. |
| `unsupportedCommand` | `information` | There is no typed decoder for the command. |
| `missingTag` | `warning` | An expected field was absent. |
| `invalidTagValue` | `warning` | A supplied field could not be decoded as expected. |
| `malformedMessage` | `error` | The envelope or known payload could not be decoded. |

A `.parsed` outcome can include recoverable warnings: it means a typed message was
produced, not that every field decoded cleanly. Decide which warnings your
application needs to surface or reject. Unused tags alone are not errors, and
`parsingLeftOvers.isEmpty` still tests for any leftovers, not just errors.

## 2. Update message construction and mutation

### Replace empty initialization followed by assignment

**Before**

```swift
var notice = Notice()
notice.kind = .global(message: "Connected")

var chat = PrivateMessage()
chat.channel = "mychannel"
chat.message = "Hello"
chat.userLogin = "viewer"
```

**After**

```swift
let notice = Notice(kind: .global(message: "Connected"))

let chat = PrivateMessage(
  channel: "mychannel",
  message: "Hello",
  userLogin: "viewer",
  id: "message-id",
  roomId: "channel-id",
  userId: "viewer-id"
)
```

Pass optional metadata through the same initializer:

```swift
let chat = PrivateMessage(
  channel: "mychannel",
  message: "Hello",
  displayName: "Viewer",
  userLogin: "viewer",
  id: "message-id",
  roomId: "channel-id",
  userId: "viewer-id"
)
```

The same construction pattern applies to the other message models and their
payload types. Initializers require explicit arguments for identifying fields;
they do not validate that caller-supplied ID or channel strings are nonempty.

### Parsed properties are read-only

Declaring an instance with `var` no longer allows assignments such as
`chat.message = "Edited"`. Construct a new instance when you need a different
library value, or keep editable application state in your own model. When
reconstructing a message, pass along any metadata you intend to retain; omitted
optional arguments use their defaults.

### Required enum fields are nonoptional

`Notice.kind`, `UserNotice.messageId`, and `HostTarget.action` no longer have
implicitly unwrapped optional types. Remove force unwraps and optional handling
for these fields.

For the `notice` constructed above:

```swift
switch notice.kind {
case .global(let message):
  print(message)
case .local, .unknownLocal:
  break
}
```

Do not replace these fields with application defaults: every successfully created
instance has its required kind or action.

## Message text and inline media

`PrivateMessage.message` now contains displayable text. A properly framed `/me`
message has its `\u{1}ACTION ` prefix and trailing `\u{1}` removed and sets
`isAction` to `true`. Other text is preserved. Original framing remains available
in `MessageParseResult.rawMessage` and `text`.

Emotes are now `[Emote]` on `PrivateMessage`, `UserNotice`, and `Whisper`.
`PrivateMessage.gifs` is now `[Gif]`. Both are decoded once during parsing;
`parseEmotes()` and `parseGifs()` have been removed.

**Before**

```swift
for emote in chat.parseEmotes() {
  print(emote.name, emote.startIndex, emote.endIndex)
}
```

**After**

```swift
for emote in chat.emotes {
  print(emote.name, emote.range.unicodeScalarOffsets)
  if let range = emote.range.stringRange(in: chat.message) {
    print(chat.message[range])
  }
}

if chat.isAction {
  // Render the message using your application's action style.
}
```

`MessageTextRange` replaces the inclusive integer `startIndex` / `endIndex`
properties on `Emote` and `Gif`. Its offsets count Unicode scalars and use an
exclusive upper bound: wire range `0-4` becomes `0..<5`. Every range refers to
its enclosing message's exposed text, including action messages. Do not strip
`ACTION` framing again or reuse offsets after modifying the message.

`range.text(in:)` returns the scalar substring or nil for out-of-bounds offsets.
`range.stringRange(in:)` additionally returns nil when a boundary falls inside a
composed Swift character. Neither helper rounds or clamps offsets. For example,
`Kappa` in `👋🏽 Kappa` occupies scalar offsets `3..<8`, despite starting at Swift
character offset 2.

For explicit construction, pass typed arrays and normalized text. Set `isAction`
when constructing an action. Both media types have public initializers taking a
validated `MessageTextRange`:

```swift
let range = MessageTextRange(unicodeScalarOffsets: 3..<8)!
let emote = Emote(id: "25", name: "Kappa", range: range)
let chat = PrivateMessage(
  channel: "example", message: "👋🏽 Kappa", userLogin: "viewer",
  emotes: [emote], id: "message-id", roomId: "channel-id", userId: "user-id"
)
```

Malformed media entries are omitted and reported as `invalidTagValue` diagnostics;
valid entries and the message survive. Raw tag values remain in the raw envelope.
`Emote.isAnimated` was removed: an IRC emote ID does not provide reliable animation
metadata. Resolve image formats in the application using Twitch's assets/API.
GIF URLs retain their original value.

## Structured badges and badge metadata

All `badges` properties and initializer arguments are now `[Badge]`, including
`SharedChatSource.badges` and the `MessageWithBadges` protocol. All `badgeInfo`
properties and arguments are now `[BadgeInfo]`.

**Before**

```swift
for badge in chat.badges {
  let parts = badge.split(separator: "/")
  print(parts[0], parts[1])
}
```

**After**

```swift
for badge in chat.badges {
  print(badge.setID, badge.version)
}

let subscriber = chat.badgeInfo.first { $0.setID == "subscriber" }
print(subscriber?.value as Any)

let badge = Badge(setID: "subscriber", version: "0")
let info = BadgeInfo(setID: "subscriber", value: "30")
```

Badge versions select assets; badge metadata carries additional information.
For example, `subscriber/0` in `badges` and `subscriber/30` in `badge-info`
represent an asset version and subscription tenure respectively. They remain
separate values. IDs, versions, and metadata are strings so unfamiliar badge
sets and nonnumeric versions survive parsing. Order and duplicates are preserved.
Malformed entries produce diagnostics and are omitted; valid entries survive.
Raw values remain available in the raw envelope.

Role helpers such as `isMod` and `isSubscriber` remain available. They now match
exact set IDs; names such as `subscriber_extra` do not imply subscriber status.
Both `moderator` and `lead_moderator` continue to satisfy `isMod`.

## 3. Handle optional payloads and fields

### Absent feature payloads are nil

The following properties now use optional payloads:

- `PrivateMessage.replyParent`
- `PrivateMessage.replyThreadParent`
- `PrivateMessage.pinnedChat`
- `PrivateMessage.source`
- `UserNotice.source`

**Before**

```swift
if !chat.replyParent.id.isEmpty {
  print("Reply to \(chat.replyParent.userLogin)")
}

if !chat.source.roomId.isEmpty {
  print("Originally from \(chat.source.roomId)")
}
```

**After**

```swift
if let reply = chat.replyParent {
  print("Reply to \(reply.userLogin ?? "unknown user")")
}

if let source = chat.source {
  print("Originally from \(source.roomId ?? "unknown channel")")
}

if let pinned = chat.pinnedChat {
  print("Pinned amount: \(pinned.amount.map(String.init) ?? "unavailable")")
}
```

No feature tags means no payload. Partial metadata is preserved as a present
payload whose individual fields can be nil. Consequently, unwrapping a payload
alone does not guarantee that every ID, display name, or numeric value is present.

### Distinguish missing values from explicit false or zero

**Before**

```swift
if chat.firstMessage {
  print("First message")
}
// false could also mean Twitch omitted the tag.
```

**After**

```swift
switch chat.firstMessage {
case .some(true):
  print("First message")
case .some(false):
  print("Not their first message")
case .none:
  print("Twitch didn't supply that information")
}
```

When the distinction does not matter:

```swift
if chat.firstMessage == true {
  print("First message")
}
```

An explicitly supplied zero or false remains present. Missing optional metadata
is nil; an unset color or empty optional identifier also becomes nil. For these optional fields, invalid
numeric or Boolean values produce nil and a diagnostic instead of a fabricated
zero or false.

The main scalar changes are:

| Model | Optional fields |
| --- | --- |
| `PrivateMessage` | `bits`, `color`, `emoteOnly`, `firstMessage`, `returningChatter`, `messageId`, `crowdChantParentMessageId`, `customRewardId`, `sourceOnly`, `tmiSentTs`, `clientNonce` |
| `UserNotice` | `color`, `vip`, `sourceMessageId`, `tmiSentTs` |
| `GlobalUserState` | `color` |
| `UserState` | `color`, `id`, `clientNonce` |
| `Whisper` | `color`, `messageId`, `threadId` |
| `ClearMessage` | `tmiSentTs` |
| `UserNotice.MessageID.ViewerMilestoneInfo` | `copoReward` |

`bits` remains a string when present, and timestamps remain millisecond counts;
this migration does not introduce numeric conversions or change their units.

### Apply partial room settings without resetting omitted values

`RoomState.emoteOnly`, `followersOnly`, `r9k`, `slow`, `subsOnly`, and `rituals` are
optional. A `ROOMSTATE` message can update only some settings. Nil means that the
message did not supply a usable value for that setting; it does not mean the
setting was disabled.

For example, given an application's existing `currentEmoteOnly` Boolean and a
parsed `update: RoomState`:

```swift
if let emoteOnly = update.emoteOnly {
  currentEmoteOnly = emoteOnly
}
```

Use the same pattern for the other settings. Avoid `update.emoteOnly ?? false`
when applying a partial update, since that would reset an omitted setting. Invalid
values remain visible in diagnostics.

### Viewer milestone rewards are optional unofficial metadata

If you previously read `info.copoReward` as a `UInt`, handle a `UInt?` instead.
The value represents Channel Points awarded for a viewer milestone. The wire tag
is unofficial and can be absent; nil is distinct from an explicitly supplied zero.
The property is still named `copoReward` in this API.

## 4. Update exhaustive switches and unknown notice handling

When migrating an exhaustive switch, account for the cases present in the new
version. Notable additions relative to older 1.x releases include:

- `UserNotice.MessageID.modiversary(ModiversaryInfo)`
- `UserNotice.MessageID.unknown(rawMessageId: String)`
- `UserNotice.MessageID.sharedChatNotice(sourceNotice: MessageID?)`
- `Notice.Kind.unknownLocal(channel:message:messageId:)`

Use explicit cases when the application needs their payloads. A default branch is
appropriate when the application intentionally ignores other event categories.

Unknown `USERNOTICE` categories no longer yield a nil typed message. They produce
`.userNotice` with an `.unknown` category; common fields and unconsumed event tags
survive. An unknown IRC command, in contrast, produces an `.unsupported` parsing
outcome. Missing or empty `msg-id` values still make a `USERNOTICE` payload
malformed.

`UserNotice.rawMessageId` contains the received `msg-id`. For Shared Chat notices,
`sourceMessageId` contains the optional source notice category, while
`source?.id` identifies the originating message. An unrecognized Shared Chat source
category still produces `.sharedChatNotice(sourceNotice: nil)` and retains its raw
category and unconsumed tags.

`isMod` now recognizes both ordinary moderator and lead moderator badges. Existing
call sites need no changes, but lead moderators will now correctly return true.

## 5. Point your dependency at the fork

Use this dependency declaration to adopt 2.0.0:

```swift
.package(url: "https://github.com/LosFarmosCTL/TwitchIRC", from: "2.0.0"),
```

Keep `import TwitchIRC` and the `TwitchIRC` product dependency. Existing users of
the original repository must deliberately change the repository URL; releases of
this fork do not automatically replace their upstream dependency.
