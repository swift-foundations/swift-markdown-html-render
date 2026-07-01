//
//  PlainText Performance Tests.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension `Performance Tests` {
    @Suite
    struct `Plain Text Extraction` {
        @Test(.timed(threshold: .seconds(5)))
        func `strip markup from simple document 500 times`() {
            let content = "This is **bold** and *italic* with `code` and [links](url)."
            for _ in 0..<500 {
                _ = String(stripping: content)
            }
        }

        @Test(.timed(threshold: .seconds(5)))
        func `strip markup from complex document 100 times`() {
            let content = """
                # Title

                This is **bold** and *italic* with `code`.

                - Item with **emphasis**
                - Item with [link](url)
                - Item with `inline code`

                ## Another heading

                More ***deeply nested*** formatting.
                """
            for _ in 0..<100 {
                _ = String(stripping: content)
            }
        }
    }
}
