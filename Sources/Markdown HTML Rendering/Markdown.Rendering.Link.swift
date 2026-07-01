import CSS_HTML_Rendering
import HTML_Rendering

extension Markdown.Rendering {
    public struct Link: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Link {
    public struct Input: Sendable {
        public let destination: String?
        public let title: String?
        public let children: [Markdown.Rendering.Action]

        public init(destination: String?, title: String?, children: [Markdown.Rendering.Action]) {
            self.destination = destination
            self.title = title
            self.children = children
        }
    }
}

extension Markdown.Rendering.Link {
    public static var `default`: Self {
        .init { input in
            Markdown.Rendering.capture {
                Anchor(href: .init(input.destination ?? "#")) {
                    Markdown.Rendering.Replay(actions: input.children)
                }
                .attribute(Title.tag, input.title)
            }
        }
    }
}
