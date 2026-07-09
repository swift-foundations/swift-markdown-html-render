//
//  Markdown Rendering Performance Tests.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension `Performance Tests` {
    @Suite
    struct `Markdown Rendering` {
        @Test(.timed(threshold: .seconds(5)))
        func `simple paragraph rendering 100 times`() throws {
            for _ in 0..<100 {
                let markdown = Markdown { "This is a simple paragraph of text." }
                _ = try String(markdown)
            }
        }

        @Test(.timed(threshold: .seconds(5)))
        func `heading rendering 100 times`() throws {
            for _ in 0..<100 {
                let markdown = Markdown { "# Hello World" }
                _ = try String(markdown)
            }
        }

        @Test(.timed(threshold: .seconds(5)))
        func `complex document rendering 50 times`() throws {
            let content = """
                # Title

                This is an introduction paragraph with **bold** and *italic* text.

                ## Section 1

                Some content with `inline code` and a [link](https://example.com).

                ```swift
                let x = 1
                let y = 2
                ```

                ## Section 2

                - Item 1
                - Item 2
                - Item 3

                > This is a blockquote

                | Header 1 | Header 2 |
                |----------|----------|
                | Cell 1   | Cell 2   |

                ---

                Final paragraph.
                """
            for _ in 0..<50 {
                let markdown = Markdown { content }
                _ = try String(markdown)
            }
        }

        @Test(.timed(threshold: .seconds(5)))
        func `multiple headings rendering 50 times`() throws {
            let content = (1...20).map { "## Section \($0)\n\nContent for section \($0)." }
                .joined(separator: "\n\n")
            for _ in 0..<50 {
                let markdown = Markdown { content }
                _ = try String(markdown)
            }
        }
    }
}
