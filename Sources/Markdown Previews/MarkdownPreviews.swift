//
//  MarkdownPreviews.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS))
import SwiftUI
import HTML_Renderable
@testable import Markdown_HTML_Rendering

#Preview("Heading") {
    HTML.Document {
        Markdown.HTML() {
            "# Hello World"
        }
    }
}

#Preview("Paragraph") {
    HTML.Document {
        Markdown.HTML() {
            "This is a paragraph with some text."
        }
    }
}

#Preview("Code Block") {
    HTML.Document {
        Markdown.HTML() {
            """
            ```swift
            let x = 1
            print(x)
            ```
            """
        }
    }
}

#Preview("Blockquote") {
    HTML.Document {
        Markdown.HTML() {
            "> This is a quote"
        }
    }
}

#Preview("Link") {
    HTML.Document {
        Markdown.HTML() {
            "[Link to Example](https://example.com)"
        }
    }
}

#Preview("Ordered List") {
    HTML.Document {
        Markdown.HTML() {
            """
            1. First item
            2. Second item
            3. Third item
            """
        }
    }
}

#Preview("Unordered List") {
    HTML.Document {
        Markdown.HTML() {
            """
            - Apple
            - Banana
            - Cherry
            """
        }
    }
}

#Preview("Table") {
    HTML.Document {
        Markdown.HTML() {
            """
            | Header 1 | Header 2 |
            |----------|----------|
            | Cell 1   | Cell 2   |
            | Cell 3   | Cell 4   |
            """
        }
    }
}

#Preview("Emphasis") {
    HTML.Document {
        Markdown.HTML() {
            "*italic* and **bold** and ***both***"
        }
    }
}

#Preview("Inline Code") {
    HTML.Document {
        Markdown.HTML() {
            "Use `print()` to output text"
        }
    }
}

#Preview("Image") {
    HTML.Document {
        Markdown.HTML() {
            "![Alt text](https://via.placeholder.com/150)"
        }
    }
}

#Preview("Thematic Break") {
    HTML.Document {
        Markdown.HTML() {
            """
            Before the break

            ---

            After the break
            """
        }
    }
}

#Preview("Complex Document") {
    HTML.Document {
        Markdown.HTML() {
            """
            # Welcome

            This is a **complex** document with multiple elements.

            ## Features

            - Lists
            - Code blocks
            - Tables

            ```swift
            func greet() {
                print("Hello!")
            }
            ```

            > Important note here

            | Feature | Status |
            |---------|--------|
            | Lists   | ✓      |
            | Code    | ✓      |
            """
        }
    }
}

#Preview("Diagnostic Error") {
    HTML.Document {
        Diagnostic(level: .error) {
            Markdown.HTML() {
                "This is an **error** message"
            }
        }
    }
}

#Preview("Diagnostic Warning") {
    HTML.Document {
        Diagnostic(level: .warning) {
            Markdown.HTML() {
                "This is a **warning** message"
            }
        }
    }
}

#Preview("Timestamp") {
    HTML.Document {
        Markdown.HTML() {
            """
            # Episode 1
            @T(0:00) John
            Welcome to the show!

            @T(1:30) Jane
            Thanks for having me.
            """
        }
    }
}
#endif
