import CSS_HTML_Rendering
import CSS_Theming
@_spi(DynamicHTML) import HTML_Rendering_Core
import HTML_Rendering
import SwiftMarkdown

extension Markdown.Rendering {
    public struct BlockQuote: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.BlockQuote {
    public struct Input: Sendable {
        public let kind: String
        public let children: [Markdown.Rendering.Action]
        public let isDiagnostic: Bool
        public let diagnosticLevel: Markdown.Diagnostic.Level?

        public init(
            kind: String,
            children: [Markdown.Rendering.Action],
            isDiagnostic: Bool,
            diagnosticLevel: Markdown.Diagnostic.Level?
        ) {
            self.kind = kind
            self.children = children
            self.isDiagnostic = isDiagnostic
            self.diagnosticLevel = diagnosticLevel
        }
    }
}

extension Markdown.Rendering.BlockQuote {
    public static var `default`: Self {
        .init { input in
            if let level = input.diagnosticLevel {
                return Markdown.Rendering.capture {
                    Markdown.Diagnostic(level: level) {
                        Markdown.Rendering.Replay(actions: input.children)
                    }
                    .css
                    .paddingLeft(PaddingLeft.rem(1))
                    .paddingRight(PaddingRight.rem(1))
                }
            } else {
                let style = SwiftMarkdown.BlockQuote.Style(blockName: input.kind)
                return Markdown.Rendering.capture {
                    HTML_Rendering.BlockQuote {
                        VStack(spacing: .rem(0.5)) {
                            StrongImportance {
                                HTML.Text(input.kind)
                            }
                            .css
                            .color(style.borderColor)

                            Markdown.Rendering.Replay(actions: input.children)
                        }
                    }
                    .css
                    .color(DarkModeColor.offBlack)
                    .backgroundColor(style.backgroundColor)
                    .border(width: .px(2), style: .solid, color: style.borderColor)
                    .borderRadius(BorderRadius.uniform(.px(6)))
                    .margin(Margin.sides(vertical: .rem(0.5), horizontal: .zero))
                    .padding(Padding.sides(vertical: .rem(1), horizontal: .rem(1.5)))
                }
            }
        }
    }
}
