//
//  MarkdownPreviews.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS))
    import SwiftUI
    import HTML_Rendering_Core
    @testable import Markdown_HTML_Rendering

    #Preview("Heading") {
        HTML.Document {
            Markdown {
                "# Hello World"
            }
        }
    }

    #Preview("Paragraph") {
        HTML.Document {
            Markdown {
                "This is a paragraph with some text."
            }
        }
    }

    #Preview("Code Block") {
        HTML.Document {
            Markdown {
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
            Markdown {
                "> This is a quote"
            }
        }
    }

    #Preview("Link") {
        HTML.Document {
            Markdown {
                "[Link to Example](https://example.com)"
            }
        }
    }

    #Preview("Ordered List") {
        HTML.Document {
            Markdown {
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
            Markdown {
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
            Markdown {
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
            Markdown {
                "*italic* and **bold** and ***both***"
            }
        }
    }

    #Preview("Inline Code") {
        HTML.Document {
            Markdown {
                "Use `print()` to output text"
            }
        }
    }

    #Preview("Image") {
        HTML.Document {
            Markdown {
                "![Alt text](https://via.placeholder.com/150)"
            }
        }
    }

    #Preview("Thematic Break") {
        HTML.Document {
            Markdown {
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
            Markdown {
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
            Markdown.Diagnostic(level: .error) {
                Markdown {
                    "This is an **error** message"
                }
            }
        }
    }

    #Preview("Diagnostic Warning") {
        HTML.Document {
            Markdown.Diagnostic(level: .warning) {
                Markdown {
                    "This is a **warning** message"
                }
            }
        }
    }

    #Preview("Timestamp") {
        HTML.Document {
            Markdown {
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
