
extension Markdown.Rendering {
    public struct Text: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Text {
    public struct Input: Sendable {
        public let text: String

        public init(text: String) {
            self.text = text
        }
    }
}

extension Markdown.Rendering.Text {
    public static var `default`: Self {
        .init { input in
            [.text(input.text)]
        }
    }
}
