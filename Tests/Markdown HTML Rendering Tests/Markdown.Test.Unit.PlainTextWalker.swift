//
//  Markdown.Test.Unit.PlainTextWalker.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `PlainTextWalker` {
        @Test
        func `strips emphasis from text`() {
            let result = String(stripping: "*italic* text")
            #expect(result == "italic text")
        }

        @Test
        func `strips strong from text`() {
            let result = String(stripping: "**bold** text")
            #expect(result == "bold text")
        }

        @Test
        func `strips inline code`() {
            let result = String(stripping: "use `print()` to output")
            #expect(result == "use print() to output")
        }

        @Test
        func `strips links leaving text`() {
            let result = String(stripping: "[Link text](https://example.com)")
            #expect(result == "Link text")
        }

        @Test
        func `strips heading markers`() {
            let result = String(stripping: "# Hello World")
            #expect(result == "Hello World")
        }

        @Test
        func `strips nested markup`() {
            let result = String(stripping: "**bold *and italic***")
            #expect(result == "bold and italic")
        }

        @Test
        func `plain text passes through unchanged`() {
            let result = String(stripping: "Just plain text")
            #expect(result == "Just plain text")
        }

        @Test
        func `handles unordered list items`() {
            let result = String(stripping: "- Item 1\n- Item 2")
            #expect(result.contains("Item 1"))
            #expect(result.contains("Item 2"))
        }
    }
}
