//
//  Markdown.Test.Unit.SlugGenerator.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `SlugGenerator` {
        @Test
        func `default generator converts text to lowercase slug`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello World",
                existingSlugs: []
            )
            #expect(gen.generate(input) == "hello-world")
        }

        @Test
        func `default generator strips non-alphanumeric characters`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello, World! How's it going?",
                existingSlugs: []
            )
            #expect(gen.generate(input) == "hello-world-how-s-it-going")
        }

        @Test
        func `default generator deduplicates existing slugs`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello",
                existingSlugs: ["hello"]
            )
            #expect(gen.generate(input) == "hello-1")
        }

        @Test
        func `default generator deduplicates multiple collisions`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello",
                existingSlugs: ["hello", "hello-1", "hello-2"]
            )
            #expect(gen.generate(input) == "hello-3")
        }

        @Test
        func `prefixed generator prepends prefix`() {
            let gen = Markdown.Configuration.SlugGenerator.prefixed("doc")
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello World",
                existingSlugs: []
            )
            #expect(gen.generate(input) == "doc-hello-world")
        }

        @Test
        func `prefixed generator deduplicates with prefix`() {
            let gen = Markdown.Configuration.SlugGenerator.prefixed("doc")
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello",
                existingSlugs: ["doc-hello"]
            )
            #expect(gen.generate(input) == "doc-hello-1")
        }

        @Test
        func `custom generator uses provided transform`() {
            let gen = Markdown.Configuration.SlugGenerator.custom { text in
                text.uppercased().replacingOccurrences(of: " ", with: "_")
            }
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello World",
                existingSlugs: []
            )
            #expect(gen.generate(input) == "HELLO_WORLD")
        }

        @Test
        func `custom generator deduplicates`() {
            let gen = Markdown.Configuration.SlugGenerator.custom { text in
                text.lowercased()
            }
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "hello",
                existingSlugs: ["hello"]
            )
            #expect(gen.generate(input) == "hello-1")
        }

        @Test
        func `default generator handles numbers in text`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Chapter 1 Introduction",
                existingSlugs: []
            )
            #expect(gen.generate(input) == "chapter-1-introduction")
        }

        @Test
        func `default generator handles single word`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Overview",
                existingSlugs: []
            )
            #expect(gen.generate(input) == "overview")
        }
    }
}
