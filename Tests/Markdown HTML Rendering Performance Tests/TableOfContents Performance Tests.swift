//
//  TableOfContents Performance Tests.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension `Performance Tests` {
    @Suite
    struct `Table Of Contents` {
        @Test(.timed(threshold: .seconds(5)))
        func `extract table of contents from 50 heading document 100 times`() {
            let content = (1...50).map { "## Section \($0)\n\nContent for section \($0)." }
                .joined(separator: "\n\n")
            for _ in 0..<100 {
                let toc = Markdown.tableOfContents(from: content)
                _ = toc.count
            }
        }

        @Test(.timed(threshold: .seconds(5)))
        func `extract table of contents with timestamps 100 times`() {
            let content = (1...20).map { i in
                "## Section \(i)\n@T(\(i):00)\nContent for section \(i)."
            }.joined(separator: "\n\n")
            for _ in 0..<100 {
                let toc = Markdown.tableOfContents(from: content)
                _ = toc.count
            }
        }
    }
}
