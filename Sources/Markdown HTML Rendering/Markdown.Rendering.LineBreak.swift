import HTML_Rendering

extension Markdown.Rendering {
    public struct LineBreak: Sendable {
        public var render: @Sendable () -> [Render.Action]

        public init(render: @escaping @Sendable () -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.LineBreak {
    private static let cached = Markdown.Rendering.capture { BR() }

    public static var `default`: Self {
        .init { cached }
    }
}
