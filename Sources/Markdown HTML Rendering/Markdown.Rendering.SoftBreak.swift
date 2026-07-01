
extension Markdown.Rendering {
    public struct SoftBreak: Sendable {
        public var render: @Sendable () -> [Render.Action]

        public init(render: @escaping @Sendable () -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.SoftBreak {
    public static var `default`: Self {
        .init {
            [.text(" ")]
        }
    }
}
