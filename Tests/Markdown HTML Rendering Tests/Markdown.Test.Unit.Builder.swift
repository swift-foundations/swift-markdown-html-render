//
//  Markdown.Test.Unit.Builder.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `Builder` {
        @Test
        func `buildBlock with no arguments returns empty`() {
            let result = Markdown.Builder.buildBlock()
            #expect(result.isEmpty)
        }

        @Test
        func `buildBlock with variadic strings returns all strings`() {
            let result = Markdown.Builder.buildBlock("# Hello", "World")
            #expect(result == ["# Hello", "World"])
        }

        @Test
        func `buildBlock with array of arrays flattens`() {
            let result = Markdown.Builder.buildBlock(["a", "b"], ["c"])
            #expect(result == ["a", "b", "c"])
        }

        @Test
        func `buildExpression wraps single string in array`() {
            let result = Markdown.Builder.buildExpression("hello")
            #expect(result == ["hello"])
        }

        @Test
        func `buildExpression passes through array`() {
            let result = Markdown.Builder.buildExpression(["a", "b"])
            #expect(result == ["a", "b"])
        }

        @Test
        func `buildExpression flattens nested arrays`() {
            let result = Markdown.Builder.buildExpression([["a"], ["b", "c"]])
            #expect(result == ["a", "b", "c"])
        }

        @Test
        func `buildExpression with nil string returns empty`() {
            let value: String? = nil
            let result = Markdown.Builder.buildExpression(value)
            #expect(result.isEmpty)
        }

        @Test
        func `buildExpression with non-nil string returns wrapped`() {
            let value: String? = "hello"
            let result = Markdown.Builder.buildExpression(value)
            #expect(result == ["hello"])
        }

        @Test
        func `buildOptional with nil returns empty`() {
            let result = Markdown.Builder.buildOptional(nil)
            #expect(result.isEmpty)
        }

        @Test
        func `buildOptional with value passes through`() {
            let result = Markdown.Builder.buildOptional(["hello"])
            #expect(result == ["hello"])
        }

        @Test
        func `buildEither first passes through`() {
            let result = Markdown.Builder.buildEither(first: ["a"])
            #expect(result == ["a"])
        }

        @Test
        func `buildEither second passes through`() {
            let result = Markdown.Builder.buildEither(second: ["b"])
            #expect(result == ["b"])
        }

        @Test
        func `buildArray flattens nested arrays`() {
            let result = Markdown.Builder.buildArray([["a", "b"], ["c"]])
            #expect(result == ["a", "b", "c"])
        }

        @Test
        func `buildLimitedAvailability passes through`() {
            let result = Markdown.Builder.buildLimitedAvailability(["a"])
            #expect(result == ["a"])
        }

        @Test
        func `buildFinalResult joins with newline`() {
            let result = Markdown.Builder.buildFinalResult(["# Hello", "World"])
            #expect(result == "# Hello\nWorld")
        }

        @Test
        func `string init with markdown builder composes correctly`() {
            let result = String(markdown: {
                "# Title"
                "Some content"
            })
            #expect(result == "# Title\nSome content")
        }

        @Test
        func `buildFinalResultWithParagraphs filters empty and double-spaces`() {
            let result = Markdown.Builder.buildFinalResultWithParagraphs(
                ["# Title", "", "Content"]
            )
            #expect(result == "# Title\n\nContent")
        }

        @Test
        func `processMarkdownSections handles blank line separation`() {
            let result = Markdown.Builder.processMarkdownSections(
                ["# Title", "", "Paragraph 1", "Paragraph 2"]
            )
            #expect(result == "# Title\n\nParagraph 1\nParagraph 2")
        }
    }
}
