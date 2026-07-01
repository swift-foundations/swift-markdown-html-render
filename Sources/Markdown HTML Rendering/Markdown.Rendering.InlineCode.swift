import HTML_Rendering

extension Markdown.Rendering {
    public struct InlineCode: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.InlineCode {
    public struct Input: Sendable {
        public let code: String

        public init(code: String) {
            self.code = code
        }
    }
}

extension Markdown.Rendering.InlineCode {
    // InlineCode has dynamic content (input.code) — Frame with Placeholder
    // for the text, but code text is the "child" of the <code> element.
    private static let frame = Markdown.Rendering.Frame {
        Code {
            Markdown.Rendering.Frame.Placeholder()
        }
    }

    public static var `default`: Self {
        .init { input in frame.applying(children: [.text(input.code)]) }
    }
}
