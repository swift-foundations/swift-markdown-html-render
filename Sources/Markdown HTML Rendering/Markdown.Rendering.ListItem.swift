import CSS_HTML_Rendering
import HTML_Rendering

extension Markdown.Rendering {
    public struct ListItem: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.ListItem {
    public struct Input: Sendable {
        public let children: [Markdown.Rendering.Action]

        public init(children: [Markdown.Rendering.Action]) {
            self.children = children
        }
    }
}

extension Markdown.Rendering.ListItem {
    private static let frame = Markdown.Rendering.Frame {
        HTML_Rendering.ListItem {
            VStack(spacing: .rem(0.5)) {
                Markdown.Rendering.Frame.Placeholder()
            }
        }
    }

    public static var `default`: Self {
        .init { input in frame.applying(children: input.children) }
    }
}
