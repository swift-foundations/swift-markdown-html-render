//
//  Markdown.Test.Integration.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Integration {
    @Suite
    struct `TableOfContents` {
        @Test
        func `extracts headings with timestamps from markdown`() {
            let toc = Markdown.tableOfContents(from: """
                # Section 1
                @T(0:00)
                Content
                ## Section 1.1
                @T(1:00)
                More content
                # Section 2
                @T(2:00)
                Final content
                """)
            #expect(toc.count == 3)
            #expect(toc[0].title == "Section 1")
            #expect(toc[0].level == 1)
            #expect(toc[1].title == "Section 1.1")
            #expect(toc[1].level == 2)
            #expect(toc[2].title == "Section 2")
            #expect(toc[2].level == 1)
        }

        @Test
        func `headings without timestamps not in table of contents`() {
            let toc = Markdown.tableOfContents(from: """
                # Section 1
                Content
                ## Section 1.1
                More content
                """)
            #expect(toc.isEmpty)
        }

        @Test
        func `empty markdown returns empty table of contents`() {
            let toc = Markdown.tableOfContents(from: "")
            #expect(toc.isEmpty)
        }

        @Test
        func `markdown without headings returns empty`() {
            let toc = Markdown.tableOfContents(from: "Just a paragraph of text.")
            #expect(toc.isEmpty)
        }

        @Test
        func `headings get unique slugs`() {
            let toc = Markdown.tableOfContents(from: """
                # Hello
                @T(0:00)
                Text
                # Hello
                @T(1:00)
                Text
                """)
            #expect(toc.count == 2)
            #expect(toc[0].id != toc[1].id)
            #expect(toc[0].id == "hello")
            #expect(toc[1].id == "hello-1")
        }

        @Test
        func `table of contents with timestamps`() {
            let toc = Markdown.tableOfContents(from: """
                # Section 1
                @T(0:00)
                Content
                ## Section 1.1
                @T(1:00)
                More content
                # Section 2
                @T(2:00)
                Final content
                """)
            #expect(toc.count == 3)
            #expect(toc[0].timestamp?.duration == 0)
            #expect(toc[1].timestamp?.duration == 60)
            #expect(toc[2].timestamp?.duration == 120)
        }
    }

    @Suite
    struct `MarkdownRendering` {
        @Test
        func `markdown init with builder produces view`() {
            let markdown = Markdown { "# Hello World" }
            _ = markdown
        }

        @Test
        func `markdown with custom configuration`() {
            let config = Markdown.Configuration(
                slugGenerator: .prefixed("test")
            )
            let toc = Markdown.tableOfContents(
                from: "# Hello\n@T(0:00)\nContent",
                configuration: config
            )
            #expect(toc.first?.id == "test-hello")
        }
    }

    @Suite
    struct `DiagnosticStyle` {
        @Test
        func `default diagnostic style resolves standard names`() {
            let style = Markdown.Configuration.Style.DiagnosticStyle.default
            #expect(style.level("Error") != nil)
            #expect(style.level("Warning") != nil)
            #expect(style.level("Expected Failure") != nil)
            #expect(style.level("Failed") != nil)
            #expect(style.level("Runtime Warning") != nil)
        }

        @Test
        func `default diagnostic style returns nil for unknown`() {
            let style = Markdown.Configuration.Style.DiagnosticStyle.default
            #expect(style.level("Unknown") == nil)
            #expect(style.level("Note") == nil)
        }

        @Test
        func `adding custom diagnostic level`() {
            let style = Markdown.Configuration.Style.DiagnosticStyle.default
                .adding("Custom", .error)
            #expect(style.level("Custom") != nil)
            #expect(style.level("Error") != nil)
        }
    }

    @Suite
    struct `BlockQuoteStyle` {
        @Test
        func `default block quote style resolves standard names`() {
            let style = Markdown.Configuration.Style.BlockQuoteStyle.default
            let warning = style.style("Warning")
            _ = warning.backgroundColor
            _ = warning.borderColor
        }

        @Test
        func `adding custom block quote style`() {
            let style = Markdown.Configuration.Style.BlockQuoteStyle.default
                .adding(
                    "Custom",
                    backgroundColor: .background.info,
                    borderColor: .border.info
                )
            let custom = style.style("Custom")
            _ = custom.backgroundColor
        }
    }
}
