#if canImport(SwiftUI) && (os(macOS) || os(iOS))
    import SwiftUI
    import HTML_Rendering
    @_spi(DynamicHTML) import HTML_Rendering_Core
    import CSS_HTML_Rendering
    @testable import Markdown_HTML_Rendering

    #Preview("Custom Slug - Prefixed") {
        HTML.Document {
            Markdown(
                configuration: {
                    var c = Markdown.Configuration.default
                    c.slugGenerator = .prefixed("doc")
                    return c
                }()
            ) {
                """
                # Introduction

                Some text here.

                ## Getting Started

                More text here.
                """
            }
        }
    }

#endif
