//
//  Pipeline Comparison Tests.swift
//  swift-markdown-html-rendering
//
//  Compares layers of the rendering pipeline at book scale to identify bottlenecks:
//  1. SwiftMarkdown parsing only (Document(parsing:))
//  2. Our action production (parse + DirectConverter)
//  3. Our full pipeline (parse + actions + interpret into HTML context)

import Markdown_HTML_Rendering
import Render_Primitives
import SwiftMarkdown
import Testing

// MARK: - Book-scale fixture (100 sections ≈ short book chapter)

private let bookChapter: String = {
    var parts: [String] = ["# Chapter: The Architecture of Rendering"]
    for i in 1...100 {
        parts.append("""
            ## Section \(i): Design Considerations

            This section explores the **design considerations** for section \(i).
            We examine *performance*, `correctness`, and maintainability in depth.
            For more details, see the [documentation](https://example.com/section/\(i)).

            The key insight from this section is that rendering pipelines benefit
            from separating operation production from interpretation. This principle
            has been validated across multiple frameworks and decades of practice.

            ### Subsection \(i).1: Implementation

            The implementation uses the following approach:

            ```swift
            func render(section: Int) {
                context.push.block(role: .heading(level: 2), style: .empty)
                context.text("Section \\(section)")
                context.pop.block()
            }
            ```

            ### Subsection \(i).2: Analysis

            Key metrics for this section:

            | Metric | Value | Status |
            |--------|-------|--------|
            | Throughput | \(i * 10) ops/s | Good |
            | Latency | \(i)ms | Acceptable |
            | Memory | \(i * 2)KB | Low |

            Important observations:

            1. The action-based pipeline scales linearly
            2. Memory usage is proportional to document size
            3. Stack depth is bounded regardless of nesting

            - First consideration for section \(i)
            - Second consideration with **bold emphasis**
            - Third consideration with `inline code`

            > **Note**: This section demonstrates that the rendering pipeline
            > handles realistic document structure without degradation.

            ---
            """)
    }
    return parts.joined(separator: "\n\n")
}()

// MARK: - Comparison Suite

extension `Performance Tests` {
    @Suite(.serialized)
    struct `Pipeline Comparison` {

        // MARK: - Layer 1: SwiftMarkdown parsing only

        @Test(.timed(iterations: 20, warmup: 2))
        func `parse only - 100 sections`() {
            let _ = SwiftMarkdown.Document(parsing: bookChapter, options: .parseBlockDirectives)
        }

        // MARK: - Layer 1b: SwiftMarkdown parse + bare HTML visitor (no CSS, no styling)

        @Test(.timed(iterations: 20, warmup: 2))
        func `swift-markdown raw HTML - 100 sections`() {
            let doc = SwiftMarkdown.Document(parsing: bookChapter, options: .parseBlockDirectives)
            var visitor = BareHTMLVisitor()
            _ = visitor.visit(doc)
        }

        // MARK: - Layer 2: Our full action pipeline → HTML

        @Test(.timed(iterations: 20, warmup: 2))
        func `full action pipeline - 100 sections`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown_HTML_Rendering.Markdown { bookChapter }
            Markdown_HTML_Rendering.Markdown._render(view, context: &context)
        }

        // MARK: - Layer 3: Old string pipeline for comparison

        @Test(.timed(iterations: 20, warmup: 2))
        func `old string pipeline - 100 sections`() throws {
            let markdown = Markdown_HTML_Rendering.Markdown { bookChapter }
            _ = try String(markdown)
        }

        // MARK: - Scale test: 500 sections (≈ full book)

        @Test(.disabled("slow — re-enable for book-scale profiling"), .timed(iterations: 3, warmup: 1))
        func `parse only - 500 sections`() {
            let content = generateBook(sections: 500)
            let _ = SwiftMarkdown.Document(parsing: content, options: .parseBlockDirectives)
        }

        @Test(.disabled("slow — re-enable for book-scale profiling"), .timed(iterations: 3, warmup: 1))
        func `full action pipeline - 500 sections`() {
            let content = generateBook(sections: 500)
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown_HTML_Rendering.Markdown { content }
            Markdown_HTML_Rendering.Markdown._render(view, context: &context)
        }

        @Test(.disabled("slow — re-enable for book-scale profiling"), .timed(iterations: 3, warmup: 1))
        func `old string pipeline - 500 sections`() throws {
            let content = generateBook(sections: 500)
            let markdown = Markdown_HTML_Rendering.Markdown { content }
            _ = try String(markdown)
        }
    }
}

// MARK: - Bare HTML Visitor (what you'd get using swift-markdown directly)

/// Minimal MarkupVisitor that produces unstyled HTML strings.
/// No CSS classes, no flexbox, no responsive styles — just raw semantic HTML.
/// This is the baseline: what swift-markdown gives you with a simple visitor.
private struct BareHTMLVisitor: SwiftMarkdown.MarkupVisitor {
    typealias Result = String

    mutating func defaultVisit(_ markup: any SwiftMarkdown.Markup) -> String {
        var result = ""
        for child in markup.children {
            result += visit(child)
        }
        return result
    }

    mutating func visitHeading(_ heading: SwiftMarkdown.Heading) -> String {
        let tag = "h\(heading.level)"
        var children = ""
        for child in heading.children { children += visit(child) }
        return "<\(tag)>\(children)</\(tag)>"
    }

    mutating func visitParagraph(_ paragraph: SwiftMarkdown.Paragraph) -> String {
        var children = ""
        for child in paragraph.children { children += visit(child) }
        return "<p>\(children)</p>"
    }

    mutating func visitText(_ text: SwiftMarkdown.Text) -> String {
        text.string
    }

    mutating func visitEmphasis(_ emphasis: SwiftMarkdown.Emphasis) -> String {
        var children = ""
        for child in emphasis.children { children += visit(child) }
        return "<em>\(children)</em>"
    }

    mutating func visitStrong(_ strong: SwiftMarkdown.Strong) -> String {
        var children = ""
        for child in strong.children { children += visit(child) }
        return "<strong>\(children)</strong>"
    }

    mutating func visitInlineCode(_ inlineCode: SwiftMarkdown.InlineCode) -> String {
        "<code>\(inlineCode.code)</code>"
    }

    mutating func visitCodeBlock(_ codeBlock: SwiftMarkdown.CodeBlock) -> String {
        "<pre><code>\(codeBlock.code)</code></pre>"
    }

    mutating func visitLink(_ link: SwiftMarkdown.Link) -> String {
        var children = ""
        for child in link.children { children += visit(child) }
        return "<a href=\"\(link.destination ?? "#")\">\(children)</a>"
    }

    mutating func visitImage(_ image: SwiftMarkdown.Image) -> String {
        "<img src=\"\(image.source ?? "")\" alt=\"\(image.plainText)\">"
    }

    mutating func visitOrderedList(_ orderedList: SwiftMarkdown.OrderedList) -> String {
        var children = ""
        for child in orderedList.children { children += visit(child) }
        return "<ol>\(children)</ol>"
    }

    mutating func visitUnorderedList(_ unorderedList: SwiftMarkdown.UnorderedList) -> String {
        var children = ""
        for child in unorderedList.children { children += visit(child) }
        return "<ul>\(children)</ul>"
    }

    mutating func visitListItem(_ listItem: SwiftMarkdown.ListItem) -> String {
        var children = ""
        for child in listItem.children { children += visit(child) }
        return "<li>\(children)</li>"
    }

    mutating func visitBlockQuote(_ blockQuote: SwiftMarkdown.BlockQuote) -> String {
        var children = ""
        for child in blockQuote.children { children += visit(child) }
        return "<blockquote>\(children)</blockquote>"
    }

    mutating func visitThematicBreak(_ thematicBreak: SwiftMarkdown.ThematicBreak) -> String {
        "<hr>"
    }

    mutating func visitLineBreak(_ lineBreak: SwiftMarkdown.LineBreak) -> String {
        "<br>"
    }

    mutating func visitSoftBreak(_ softBreak: SwiftMarkdown.SoftBreak) -> String {
        " "
    }

    mutating func visitHTMLBlock(_ html: SwiftMarkdown.HTMLBlock) -> String {
        html.rawHTML
    }

    mutating func visitInlineHTML(_ inlineHTML: SwiftMarkdown.InlineHTML) -> String {
        inlineHTML.rawHTML
    }

    mutating func visitTable(_ table: SwiftMarkdown.Table) -> String {
        var result = "<table>"
        if !table.head.isEmpty {
            result += "<thead><tr>"
            for cell in table.head.cells {
                var children = ""
                for child in cell.children { children += visit(child) }
                result += "<th>\(children)</th>"
            }
            result += "</tr></thead>"
        }
        if !table.body.isEmpty {
            result += "<tbody>"
            for row in table.body.rows {
                result += "<tr>"
                for cell in row.cells {
                    var children = ""
                    for child in cell.children { children += visit(child) }
                    result += "<td>\(children)</td>"
                }
                result += "</tr>"
            }
            result += "</tbody>"
        }
        result += "</table>"
        return result
    }

    mutating func visitStrikethrough(_ strikethrough: SwiftMarkdown.Strikethrough) -> String {
        var children = ""
        for child in strikethrough.children { children += visit(child) }
        return "<s>\(children)</s>"
    }
}

// MARK: - Generator

private func generateBook(sections: Int) -> String {
    var parts: [String] = ["# Book Title"]
    for i in 1...sections {
        parts.append("""
            ## Section \(i)

            Content for section \(i) with **bold**, *italic*, and `code`.
            Another sentence with a [link](https://example.com/\(i)).

            - Point A
            - Point B
            - Point C

            ```swift
            func section\(i)() { print("\\(i)") }
            ```

            | Col A | Col B |
            |-------|-------|
            | \(i)a | \(i)b |

            > Note for section \(i).

            ---
            """)
    }
    return parts.joined(separator: "\n\n")
}
