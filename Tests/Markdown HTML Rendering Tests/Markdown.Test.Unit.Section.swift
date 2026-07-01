//
//  Markdown.Test.Unit.Section.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `Section` {
        @Test
        func `init stores all properties`() {
            let section = Markdown.Section(
                title: "Introduction",
                id: "introduction",
                level: 1,
                timestamp: nil
            )
            #expect(section.title == "Introduction")
            #expect(section.id == "introduction")
            #expect(section.level == 1)
            #expect(section.timestamp == nil)
        }

        @Test
        func `anchor prepends hash to id`() {
            let section = Markdown.Section(
                title: "Getting Started",
                id: "getting-started",
                level: 2,
                timestamp: nil
            )
            #expect(section.anchor == "#getting-started")
        }

        @Test
        func `section with timestamp stores timestamp`() {
            let timestamp = Markdown_HTML_Rendering.Timestamp(format: "1:30", speaker: nil)
            let section = Markdown.Section(
                title: "Chapter 1",
                id: "chapter-1",
                level: 1,
                timestamp: timestamp
            )
            #expect(section.timestamp != nil)
            #expect(section.timestamp?.duration == 90)
        }
    }
}
