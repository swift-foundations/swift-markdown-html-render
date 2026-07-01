//
//  Markdown.Test.Unit.Configuration.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `Configuration` {
        @Test
        func `default configuration provides all components`() {
            let config = Markdown.Configuration.default
            _ = config.directives
            _ = config.style
            _ = config.slugGenerator
        }

        @Test
        func `custom configuration preserves provided values`() {
            let slugGen = Markdown.Configuration.SlugGenerator.prefixed("test")
            let config = Markdown.Configuration(slugGenerator: slugGen)

            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Hello World",
                existingSlugs: []
            )
            let slug = config.slugGenerator.generate(input)
            #expect(slug == "test-hello-world")
        }

        @Test
        func `default static property matches memberwise default init`() {
            let fromStatic = Markdown.Configuration.default
            let fromInit = Markdown.Configuration()

            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Test Heading",
                existingSlugs: []
            )
            #expect(
                fromStatic.slugGenerator.generate(input) == fromInit.slugGenerator.generate(input)
            )
        }
    }
}
