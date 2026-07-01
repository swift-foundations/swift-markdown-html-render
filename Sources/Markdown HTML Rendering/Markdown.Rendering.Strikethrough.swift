import HTML_Rendering

extension Markdown.Rendering {
    public struct Strikethrough: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Strikethrough {
    public struct Input: Sendable {
        public let children: [Markdown.Rendering.Action]

        public init(children: [Markdown.Rendering.Action]) {
            self.children = children
        }
    }
}

extension Markdown.Rendering.Strikethrough {
    private static let frame = Markdown.Rendering.Frame {
        HTML_Rendering.Strikethrough {
            Markdown.Rendering.Frame.Placeholder()
        }
    }

    public static var `default`: Self {
        .init { input in frame.applying(children: input.children) }
    }
}
