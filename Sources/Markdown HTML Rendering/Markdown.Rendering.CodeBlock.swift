import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Rendering {
    public struct CodeBlock: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.CodeBlock {
    public struct Input: Sendable {
        public let language: String?
        public let code: String
        public let highlightLines: String?

        public init(language: String?, code: String, highlightLines: String?) {
            self.language = language
            self.code = code
            self.highlightLines = highlightLines
        }
    }
}

extension Markdown.Rendering.CodeBlock {
    private static let preFrame = Markdown.Rendering.Frame {
        PreformattedText {
            Markdown.Rendering.Frame.Placeholder()
        }
        .css
        .color(DarkModeColor.text.primary)
        .margin(Margin.zero)
        .marginBottom(MarginBottom.rem(0.5))
        .overflowX(OverflowX.auto)
        .padding(Padding.sides(vertical: .rem(1), horizontal: .rem(1.5)))
        .borderRadius(BorderRadius.px(6))
    }

    public static var `default`: Self {
        .init { input in
            var inner: [Render.Action] = []
            if let lang = input.language {
                inner.append(.attribute(set: "class", value: "language-\(lang)"))
            }
            inner.append(.push(.element(tagName: "code", isBlock: false, isVoid: false, isPreElement: false)))
            inner.append(.text(input.code))
            inner.append(.pop(.element(isBlock: false)))

            var attributes: [Render.Action] = []
            if let highlightLines = input.highlightLines {
                attributes.append(.attribute(set: "data-line", value: highlightLines))
            }

            return preFrame.applying(children: inner, attributes: attributes)
        }
    }
}
