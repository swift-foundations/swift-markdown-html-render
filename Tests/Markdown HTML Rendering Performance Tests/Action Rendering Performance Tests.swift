//
//  Action Rendering Performance Tests.swift
//  swift-markdown-html-rendering
//
//  Measures the new action-based rendering pipeline:
//  1. Markdown → [Render.Action] (DirectConverter)
//  2. [Render.Action] → HTML bytes (interpret into HTML context)
//
//  Compared against the existing HTML string pipeline (String(markdown))
//  to validate the action path is not slower.

import Markdown_HTML_Rendering
import Render_Primitives
import Testing

// MARK: - Markdown Content Fixtures

private let simpleMarkdown = """
    # Hello World

    This is a simple paragraph with **bold** and *italic* text.
    """

private let mediumMarkdown = """
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

private let largeMarkdown: String = {
    var sections: [String] = ["# Large Document"]
    for i in 1...20 {
        sections.append("""
            ## Section \(i)

            This is paragraph content for section \(i) with **bold**, *italic*, and `code`.

            - List item A in section \(i)
            - List item B in section \(i)
            - List item C in section \(i)

            Another paragraph with a [link](https://example.com/\(i)).
            """)
    }
    return sections.joined(separator: "\n\n")
}()

// MARK: - Action Path: Markdown → Render.Context (new pipeline)

extension `Performance Tests` {
    @Suite(.serialized)
    struct `Action Rendering` {

        // MARK: - Simple document

        @Test(.timed(iterations: 200, warmup: 20))
        func `action path - simple document`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { simpleMarkdown }
            Markdown._render(view, context: &context)
        }

        @Test(.timed(iterations: 200, warmup: 20))
        func `string path - simple document`() throws {
            let markdown = Markdown { simpleMarkdown }
            _ = try String(markdown)
        }

        // MARK: - Medium document

        @Test(.timed(iterations: 100, warmup: 10))
        func `action path - medium document`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { mediumMarkdown }
            Markdown._render(view, context: &context)
        }

        @Test(.timed(iterations: 100, warmup: 10))
        func `string path - medium document`() throws {
            let markdown = Markdown { mediumMarkdown }
            _ = try String(markdown)
        }

        // MARK: - Large document (20 sections)

        @Test(.timed(iterations: 20, warmup: 2))
        func `action path - large document`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { largeMarkdown }
            Markdown._render(view, context: &context)
        }

        @Test(.timed(iterations: 20, warmup: 2))
        func `string path - large document`() throws {
            let markdown = Markdown { largeMarkdown }
            _ = try String(markdown)
        }

        // MARK: - Throughput at scale

        @Test(.timed(iterations: 500, warmup: 50))
        func `action throughput - simple`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { simpleMarkdown }
            Markdown._render(view, context: &context)
        }

        @Test(.timed(iterations: 50, warmup: 5))
        func `action throughput - medium`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { mediumMarkdown }
            Markdown._render(view, context: &context)
        }

        // MARK: - Table of contents extraction

        @Test(.timed(iterations: 100, warmup: 10))
        func `table of contents - large document`() {
            _ = Markdown.tableOfContents(from: largeMarkdown)
        }

        // MARK: - Extreme stress: documents that would stack-overflow the old pipeline

        @Test(.timed(iterations: 5, warmup: 1))
        func `action path - extreme 100 sections`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { extremeMarkdown }
            Markdown._render(view, context: &context)
        }

        @Test(.disabled("slow — re-enable for book-scale profiling"), .timed(iterations: 2, warmup: 1))
        func `action path - extreme 500 sections`() {
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { massiveMarkdown }
            Markdown._render(view, context: &context)
        }

        @Test(.disabled("slow — re-enable for book-scale profiling"))
        func `action path - extreme 1000 sections does not crash`() {
            let content = generateMarkdown(sections: 1000)
            let state = Ownership.Mutable(HTML_Rendering_Core.HTML.Context())
            var context = Render.Context.html(state: state)
            let view = Markdown { content }
            Markdown._render(view, context: &context)
            // If we get here, it didn't stack overflow.
            #expect(state.value.bytes.count > 0)
        }
    }
}

// MARK: - Extreme fixtures

private let extremeMarkdown: String = {
    generateMarkdown(sections: 100)
}()

private let massiveMarkdown: String = {
    generateMarkdown(sections: 500)
}()

private func generateMarkdown(sections: Int) -> String {
    var parts: [String] = ["# Stress Test Document"]
    for i in 1...sections {
        parts.append("""
            ## Section \(i)

            Paragraph with **bold**, *italic*, `code`, and a [link](https://example.com/\(i)).

            - Item A
            - Item B with **nested bold** and *italic*
            - Item C with `inline code`

            > Blockquote in section \(i)

            ```swift
            func section\(i)() {
                print("Hello from section \\(i)")
            }
            ```

            | Column A | Column B | Column C |
            |----------|----------|----------|
            | Row \(i)a | Row \(i)b | Row \(i)c |

            ---

            Another paragraph to close section \(i).
            """)
    }
    return parts.joined(separator: "\n\n")
}

