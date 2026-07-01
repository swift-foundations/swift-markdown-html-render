import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Rendering {
    public struct Image: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Image {
    public struct Input: Sendable {
        public let source: String?
        public let alt: String?
        public let title: String?

        public init(source: String?, alt: String?, title: String?) {
            self.source = source
            self.alt = alt
            self.title = title
        }
    }
}

extension Markdown.Rendering.Image {
    public static var `default`: Self {
        .init { input in
            guard let source = input.source else { return [] }
            return Markdown.Rendering.capture {
                VStack(alignment: .center) {
                    Anchor(href: .init(value: source)) {
                        HTML_Rendering.Image(
                            src: .init(value: source),
                            alt: .init(value: input.title ?? "")
                        )
                        .css
                        .marginTop(MarginTop.zero)
                        .marginBottom(MarginBottom.zero)
                        .marginLeft(MarginLeft.rem(1))
                        .marginRight(MarginRight.rem(1))
                        .borderRadius(BorderRadius.uniform(.px(6)))
                    }
                }
            }
        }
    }
}
