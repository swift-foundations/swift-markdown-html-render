//
//  Markdown.Test.Unit.Timestamp.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `Timestamp` {
        @Test
        func `init with minutes and seconds`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "5:30", speaker: nil)
            #expect(ts != nil)
            #expect(ts?.hour == 0)
            #expect(ts?.minute == 5)
            #expect(ts?.second == 30)
        }

        @Test
        func `init with hours minutes and seconds`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "1:23:45", speaker: nil)
            #expect(ts != nil)
            #expect(ts?.hour == 1)
            #expect(ts?.minute == 23)
            #expect(ts?.second == 45)
        }

        @Test
        func `init with seconds only`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "45", speaker: nil)
            #expect(ts != nil)
            #expect(ts?.hour == 0)
            #expect(ts?.minute == 0)
            #expect(ts?.second == 45)
        }

        @Test
        func `init with speaker stores speaker`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "1:00", speaker: "John")
            #expect(ts?.speaker == "John")
        }

        @Test
        func `init without speaker stores nil`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "1:00", speaker: nil)
            #expect(ts?.speaker == nil)
        }

        @Test
        func `init with invalid format returns nil`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "abc", speaker: nil)
            #expect(ts == nil)
        }

        @Test
        func `duration calculates total seconds`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "1:23:45", speaker: nil)!
            #expect(ts.duration == 1 * 3600 + 23 * 60 + 45)
        }

        @Test
        func `duration for short format`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "0:45", speaker: nil)!
            #expect(ts.duration == 45)
        }

        @Test
        func `duration for minutes only`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "5:00", speaker: nil)!
            #expect(ts.duration == 300)
        }

        @Test
        func `id returns t-prefixed duration`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "5:30", speaker: nil)!
            #expect(ts.id == "t330")
        }

        @Test
        func `anchor returns hash-prefixed id`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "5:30", speaker: nil)!
            #expect(ts.anchor == "#t330")
        }

        @Test
        func `formatted returns short format without leading zeros for hours`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "5:30", speaker: nil)!
            #expect(ts.formatted() == "5:30")
        }

        @Test
        func `formatted returns padded seconds`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "1:05", speaker: nil)!
            #expect(ts.formatted() == "1:05")
        }

        @Test
        func `formatted includes hours when present`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "1:23:45", speaker: nil)!
            #expect(ts.formatted() == "1:23:45")
        }

        @Test
        func `formatted pads minutes when hours present`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "2:03:07", speaker: nil)!
            #expect(ts.formatted() == "2:03:07")
        }

        @Test
        func `zero timestamp`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "0:00", speaker: nil)!
            #expect(ts.duration == 0)
            #expect(ts.formatted() == "0:00")
        }
    }
}
