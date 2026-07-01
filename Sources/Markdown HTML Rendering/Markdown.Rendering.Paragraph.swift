import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Rendering {
    public struct Paragraph: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Paragraph {
    public struct Input: Sendable {
        public let children: [Markdown.Rendering.Action]

        public init(children: [Markdown.Rendering.Action]) {
            self.children = children
        }
    }
}

extension Markdown.Rendering.Paragraph {
    private static let frame = Markdown.Rendering.Frame {
        HTML_Rendering.Paragraph {
            Markdown.Rendering.Frame.Placeholder()
        }
        .css
        .lineHeight(1.5)
        .padding(Padding.zero)
        .margin(Margin.zero)
    }

    public static var `default`: Self {
        .init { input in frame.applying(children: input.children) }
    }
}
