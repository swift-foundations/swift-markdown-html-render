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
        HTML.Markdown {
            "# Hello World"
        }
    }
}

#Preview("Paragraph") {
    HTML.Document {
        HTML.Markdown {
            "This is a paragraph with some text."
        }
    }
}

#Preview("Code Block") {
    HTML.Document {
        HTML.Markdown {
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
        HTML.Markdown {
            "> This is a quote"
        }
    }
}

#Preview("Link") {
    HTML.Document {
        HTML.Markdown {
            "[Link to Example](https://example.com)"
        }
    }
}

#Preview("Ordered List") {
    HTML.Document {
        HTML.Markdown {
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
        HTML.Markdown {
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
        HTML.Markdown {
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
        HTML.Markdown {
            "*italic* and **bold** and ***both***"
        }
    }
}

#Preview("Inline Code") {
    HTML.Document {
        HTML.Markdown {
            "Use `print()` to output text"
        }
    }
}

#Preview("Image") {
    HTML.Document {
        HTML.Markdown {
            "![Alt text](https://via.placeholder.com/150)"
        }
    }
}

#Preview("Thematic Break") {
    HTML.Document {
        HTML.Markdown("""
            Before the break

            ---

            After the break
            """)
    }
}

#Preview("Complex Document") {
    HTML.Document {
        HTML.Markdown {
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
            HTML.Markdown {
                "This is an **error** message"
            }
        }
    }
}

#Preview("Diagnostic Warning") {
    HTML.Document {
        Diagnostic(level: .warning) {
            HTML.Markdown {
                "This is a **warning** message"
            }
        }
    }
}

#Preview("Timestamp") {
    HTML.Document {
        HTML.Markdown {
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
