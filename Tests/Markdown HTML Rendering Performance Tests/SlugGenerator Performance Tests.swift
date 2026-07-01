//
//  SlugGenerator Performance Tests.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension `Performance Tests` {
    @Suite
    struct `Slug Generation` {
        @Test(.timed(threshold: .seconds(5)))
        func `generate slugs from varied headings`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            for i in 0..<1_000 {
                let input = Markdown.Configuration.SlugGenerator.Input(
                    text: "Heading Number \(i)",
                    existingSlugs: []
                )
                _ = gen.generate(input)
            }
        }
    }
}
