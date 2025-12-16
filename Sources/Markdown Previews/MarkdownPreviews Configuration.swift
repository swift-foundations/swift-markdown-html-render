//
//  MarkdownPreviews Configuration.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS))
    import SwiftUI
    import HTML_Rendering
    @_spi(DynamicHTML) import HTML_Renderable
    import CSS_HTML_Rendering
    @testable import Markdown_HTML_Rendering

    // MARK: - Custom Heading

    #Preview("Custom Heading - Centered") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default
                    c.elements.heading = .init { input in
                        tag("h\(input.level)") {
                            input.children
                        }
                        .css
                        .textAlign(.center)
                        .color(.purple)
                        .borderBottom(.init(width: .px(2), style: .solid, color: .purple))
                        .paddingBottom(PaddingBottom.rem(0.5))
                    }
                    return c
                }()
            ) {
                """
                # Centered Heading

                This heading is centered with a purple underline.
                """
            }
        }
    }

    // MARK: - Custom Code Block

    #Preview("Custom Code Block - Dark Theme") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default
                    c.elements.codeBlock = .init { input in
                        PreformattedText {
                            Code {
                                HTML.Text(input.code)
                            }
                            .attribute("class", input.language.map { "language-\($0)" })
                        }
                        .css
                        .backgroundColor(.gray900)
                        .color(.green)
                        .padding(Padding.rem(1.5))
                        .borderRadius(BorderRadius.px(12))
                        .fontFamily(.monospace)
                        .fontSize(.rem(0.875))
                        .overflowX(.auto)
                    }
                    return c
                }()
            ) {
                """
                # Code Example

                ```swift
                func hello() {
                    print("Hello, World!")
                }
                ```
                """
            }
        }
    }

    // MARK: - Custom Blockquote

    #Preview("Custom Blockquote - Styled") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default
                    c.elements.blockQuote = .init { input in
                        HTML_Rendering.BlockQuote {
                            VStack(spacing: .rem(0.5)) {
                                input.children
                            }
                        }
                        .css
                        .backgroundColor(.hex("#FFF3CD"))
                        .borderLeft(.init(width: .px(4), style: .solid, color: .hex("#FFC107")))
                        .padding(Padding.rem(1))
                        .margin(Margin.sides(vertical: .rem(1), horizontal: .zero))
                        .fontStyle(.italic)
                    }
                    return c
                }()
            ) {
                """
                # Quote Example

                > This is a custom styled blockquote with a yellow background
                > and a gold left border.
                """
            }
        }
    }

    // MARK: - Custom Link

    #Preview("Custom Link - Button Style") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default
                    c.elements.link = .init { input in
                        Anchor(href: .init(input.destination ?? "#")) {
                            input.children
                        }
                        .css
                        .display(.inlineBlock)
                        .backgroundColor(.blue)
                        .color(.white)
                        .padding(Padding.sides(vertical: .rem(0.5), horizontal: .rem(1)))
                        .borderRadius(BorderRadius.px(6))
                        .textDecoration(TextDecoration.none)
                    }
                    return c
                }()
            ) {
                """
                # Links as Buttons

                Click [this link](https://example.com) to see the button style.
                """
            }
        }
    }

    // MARK: - Custom Inline Code

    #Preview("Custom Inline Code - Pill Style") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default
                    c.elements.inlineCode = .init { input in
                        Code {
                            HTML.Text(input.code)
                        }
                        .css
                        .backgroundColor(.gray200)
                        .color(.hex("#D63384"))
                        .padding(Padding.sides(vertical: .rem(0.15), horizontal: .rem(0.4)))
                        .borderRadius(BorderRadius.px(12))
                        .fontSize(.rem(0.875))
                        .fontFamily(.monospace)
                    }
                    return c
                }()
            ) {
                """
                # Inline Code Example

                Use the `print()` function to output text.
                """
            }
        }
    }

    // MARK: - Custom Slug Generator

    #Preview("Custom Slug - Prefixed") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default
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

    // MARK: - Combined Custom Configuration

    #Preview("Combined - Blog Style") {
        HTML.Document {
            Markdown.HTML(
                configuration: {
                    var c = Markdown.HTML.Configuration.default

                    c.elements.heading = .init { input in
                        tag("h\(input.level)") {
                            input.children
                        }
                        .css
                        .fontFamily(.serif)
                        .color(.hex("#2C3E50"))
                        .marginTop(MarginTop.rem(input.level == 1 ? 0 : 1.5))
                        .marginBottom(MarginBottom.rem(0.75))
                    }

                    c.elements.paragraph = .init { input in
                        HTML_Rendering.Paragraph {
                            input.children
                        }
                        .css
                        .fontSize(.rem(1.125))
                        .lineHeight(1.75)
                        .color(.hex("#333333"))
                    }

                    c.elements.blockQuote = .init { input in
                        HTML_Rendering.BlockQuote {
                            input.children
                        }
                        .css
                        .borderLeft(.init(width: .px(3), style: .solid, color: .hex("#3498DB")))
                        .paddingLeft(PaddingLeft.rem(1.5))
                        .marginLeft(MarginLeft.zero)
                        .fontStyle(.italic)
                        .color(.hex("#555555"))
                    }

                    c.elements.codeBlock = .init { input in
                        PreformattedText {
                            Code {
                                HTML.Text(input.code)
                            }
                        }
                        .css
                        .backgroundColor(.hex("#282C34"))
                        .color(.hex("#ABB2BF"))
                        .padding(Padding.rem(1.25))
                        .borderRadius(BorderRadius.px(8))
                        .fontSize(.rem(0.9))
                        .overflowX(.auto)
                    }

                    return c
                }()
            ) {
                """
                # The Art of Swift Programming

                Swift is a powerful programming language.

                ## Why Swift?

                Swift was designed to be safe and expressive.

                ```swift
                struct Article {
                    let title: String
                }
                ```

                > Swift makes it easy to write safe software.
                """
            }
        }
    }

#endif
