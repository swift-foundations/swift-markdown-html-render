import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering
@_spi(DynamicHTML) import HTML_Rendering_Core

extension Markdown.Rendering {
    public struct Heading: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Heading {
    public struct Input: Sendable {
        public let level: Int
        public let slug: String
        public let plainText: String
        public let children: [Markdown.Rendering.Action]

        public init(
            level: Int,
            slug: String,
            plainText: String,
            children: [Markdown.Rendering.Action]
        ) {
            self.level = level
            self.slug = slug
            self.plainText = plainText
            self.children = children
        }
    }
}

extension Markdown.Rendering.Heading {

    private static let anchorTemplate: [Render.Action] = Markdown.Rendering.capture {
        HTML.Anchor.Element {}
            .id("__HEADING_SLUG__")
            .css
            .display(.block)
            .position(.relative)
            .top(Top.em(-5))
            .desktop { $0.top(Top.em(-0.5)) }
            .visibility(.hidden)
    }

    private static let wrapperFrame = Markdown.Rendering.Frame {
        HTML.ContentDivision.Element {
            Markdown.Rendering.Frame.Placeholder()
        }
        .css
        .marginLeft(MarginLeft.rem(-2.25))
        .paddingLeft(PaddingLeft.rem(2.25))
        .desktop {
            $0.marginLeft(MarginLeft.rem(-2.5))
                .paddingLeft(PaddingLeft.rem(2.5))
        }
        .position(.relative)
    }

    private static let linkIconTemplate: [Render.Action] = Markdown.Rendering.capture {
        HTML.Anchor.Element(href: .init(value: "__HEADING_SLUG__")) {
            LinkIcon()
        }
        .css
        .color(.branding.accent)
        .display(Display.none)
        .selector("article div:hover > * >") { $0.display(.initial) }
        .left(Left.zero)
        .position(.absolute)
        .mobile { $0.top(Top.px(2)) }
        .width(Width.rem(2.5))
    }

    private static let headingColorTemplate: [Render.Action] = {

        Markdown.Rendering.capture {
            tag("h1") {}
                .css
                .color(DarkModeColor.offBlack.withDarkColor(.offWhite))
        }.filter {
            switch $0 {
            case .push(.style), .pop(.style), .style: return true
            default: return false
            }
        }
    }()

    public static var `default`: Self {
        .init { input in
            var actions: [Render.Action] = []

            for action in anchorTemplate {
                if case .attribute(set: "id", value: "__HEADING_SLUG__") = action {
                    actions.append(.attribute(set: "id", value: input.slug))
                } else {
                    actions.append(action)
                }
            }

            var content: [Render.Action] = []

            content.append(contentsOf: headingColorTemplate)
            content.append(
                .push(
                    .element(
                        tagName: "h\(input.level)",
                        isBlock: true,
                        isVoid: false,
                        isPreElement: false
                    )
                )
            )
            content.append(contentsOf: input.children)

            for action in linkIconTemplate {
                if case .attribute(set: "href", value: "__HEADING_SLUG__") = action {
                    content.append(.attribute(set: "href", value: "#\(input.slug)"))
                } else {
                    content.append(action)
                }
            }

            content.append(.pop(.element(isBlock: true)))

            actions.append(contentsOf: wrapperFrame.applying(children: content))

            return actions
        }
    }
}
