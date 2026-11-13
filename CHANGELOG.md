# Changelog

<!-- Add changes under Unreleased. Move them into a new X.Y.Z section when ready.
Successful CI on main prepares a draft release; publishing remains manual. -->

## Unreleased

## 2.0.0

This release modernizes the public API and expands Twitch IRC compatibility.
It requires Swift 6.4 or later and uses Swift 6 language mode. There are no
package dependencies.

**2.0.0 is a breaking release.** See the [migration guide](https://github.com/LosFarmosCTL/TwitchIRC/blob/2.0.0/MIGRATION-2.0.md)
for before-and-after examples and the complete migration details.

### Breaking changes

- Typed tag-backed fields decode IRCv3 escapes once; raw envelopes and leftovers
  retain their original wire values.
- Parsing returns named `MessageParseResult` values with parsed, unsupported, and
  malformed outcomes, raw IRC envelopes, and structured diagnostics.
- Public message construction uses explicit initializers. Parsed properties are
  read-only, and required payload kinds no longer use implicitly unwrapped optionals.
- Missing metadata and nested payloads are represented by optionals. Partial
  `ROOMSTATE` updates preserve the distinction between absent settings and false/zero.
- Emotes and GIFs are typed collections decoded during parsing. Shared Unicode
  scalar ranges provide safe extraction and conversion to Swift string indices.
- `PrivateMessage.message` exposes normalized `/me` text with an `isAction` flag.
  Media ranges refer to the exposed text; original framing survives in the raw envelope.
- Badges and badge metadata use separate `Badge` and `BadgeInfo` values.
- Public names distinguish message IDs from categories, clarify timestamp units,
  and consistently capitalize embedded acronyms. Field documentation identifies
  the exact IRC tags. See the migration guide's naming table.
- `Emote.isAnimated` is removed because IRC IDs do not reliably describe asset formats.

### Twitch compatibility and fixes

- Recognize lead moderators in badge-based moderator checks.
- Preserve unknown `USERNOTICE` categories and their common metadata.
- Decode Modiversary notices, including Shared Chat source notices.
- Accept viewer milestone notices without unofficial reward or VIP metadata.
- Expose GIF metadata with its original URL, alongside typed media ranges.
- Reject malformed media ranges without crashing; retain valid entries and report
  diagnostics for invalid ones.

### Adopting this fork

Point SwiftPM at this repository; releases here do not replace upstream releases:

```swift
.package(url: "https://github.com/LosFarmosCTL/TwitchIRC", from: "2.0.0"),
```

The product and import remain `TwitchIRC`.
