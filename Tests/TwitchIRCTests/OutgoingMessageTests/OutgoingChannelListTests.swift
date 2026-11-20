import Testing
import TwitchIRC

struct OutgoingChannelListTests {
  @Test
  func multipleChannels() {
    #expect(OutgoingMessage.join(to: ["foo", "bar"])?.serialize() == "JOIN #foo,#bar")
    #expect(OutgoingMessage.part(from: ["foo", "bar"])?.serialize() == "PART #foo,#bar")
  }

  @Test
  func singleChannelList() {
    #expect(
      OutgoingMessage.join(to: ["foo"])?.serialize() == OutgoingMessage.join(to: "foo").serialize())
    #expect(
      OutgoingMessage.part(from: ["foo"])?.serialize()
        == OutgoingMessage.part(from: "foo").serialize())
  }

  @Test
  func emptyChannelList() {
    #expect(OutgoingMessage.join(to: []) == nil)
    #expect(OutgoingMessage.part(from: []) == nil)
  }
}
