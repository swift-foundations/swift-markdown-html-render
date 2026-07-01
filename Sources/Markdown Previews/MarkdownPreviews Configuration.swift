//
//  MarkdownPreviews Configuration.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS))
    import SwiftUI
    import HTML_Rendering
    @_spi(DynamicHTML) import HTML_Rendering_Core
    import CSS_HTML_Rendering
    @testable import Markdown_HTML_Rendering

    // MARK: - Custom Slug Generator

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
