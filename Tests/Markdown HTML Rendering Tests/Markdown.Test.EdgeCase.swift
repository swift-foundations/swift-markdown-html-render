//
//  Markdown.Test.EdgeCase.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.EdgeCase {
    @Suite
    struct `SlugGeneration` {
        @Test
        func `empty string produces empty slug`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "",
                existingSlugs: []
            )
            let slug = gen.generate(input)
            #expect(slug == "")
        }

        @Test
        func `special characters only produces empty slug`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "!@#$%^&*()",
                existingSlugs: []
            )
            let slug = gen.generate(input)
            #expect(slug == "")
        }

        @Test
        func `unicode text produces slug`() {
            let gen = Markdown.Configuration.SlugGenerator.default
            let input = Markdown.Configuration.SlugGenerator.Input(
                text: "Cafe\u{0301} Latte\u{0301}",
                existingSlugs: []
            )
            let slug = gen.generate(input)
            #expect(!slug.isEmpty)
        }
    }

    @Suite
    struct `TimestampEdgeCases` {
        @Test
        func `empty format returns nil`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "", speaker: nil)
            #expect(ts == nil)
        }

        @Test
        func `non-numeric format returns nil`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "abc:def", speaker: nil)
            #expect(ts == nil)
        }

        @Test
        func `large hour value`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "99:59:59", speaker: nil)
            #expect(ts != nil)
            #expect(ts?.duration == 99 * 3600 + 59 * 60 + 59)
        }

        @Test
        func `zero duration timestamp`() {
            let ts = Markdown_HTML_Rendering.Timestamp(format: "0:00", speaker: nil)
            #expect(ts != nil)
            #expect(ts?.duration == 0)
            #expect(ts?.id == "t0")
            #expect(ts?.anchor == "#t0")
        }
    }

    @Suite
    struct `BuilderEdgeCases` {
        @Test
        func `empty builder produces empty string`() {
            let result = String(markdown: {
                let _: [String] = []
            })
            #expect(result == "")
        }

        @Test
        func `conditional branch in builder`() {
            let showTitle = true
            let result = String(markdown: {
                if showTitle {
                    "# Title"
                }
                "Content"
            })
            #expect(result.contains("# Title"))
            #expect(result.contains("Content"))
        }
    }

    @Suite
    struct `PlainTextEdgeCases` {
        @Test
        func `empty markdown produces empty string`() {
            let result = String(stripping: "")
            #expect(result == "")
        }

        @Test
        func `deeply nested markup strips correctly`() {
            let result = String(stripping: "***bold and italic***")
            #expect(result == "bold and italic")
        }
    }
}
