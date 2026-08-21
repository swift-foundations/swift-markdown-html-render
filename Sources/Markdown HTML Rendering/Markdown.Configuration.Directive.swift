import CSS_HTML_Layout_Rendering
import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Configuration {

    public struct Directives: Sendable {
        public var handler:
            @Sendable (Directive) -> Markdown.Configuration.Directives.Directive.Result

        public init(
            _ handler:
                @escaping @Sendable (Directive) ->
                Markdown.Configuration.Directives.Directive.Result
        ) {
            self.handler = handler
        }
    }
}

extension Markdown.Configuration.Directives {
    public static var `default`: Self {
        .init { directive in
            switch directive.name {
            case "Button":
                .rendered(
                    HTML.AnyView {
                        VStack(alignment: .center) {
                            HTML.Anchor.Element(href: .init(directive.rawArguments)) {
                                directive.children
                            }
                            .css
                            .margin(Margin.sides(vertical: .rem(0.5), horizontal: .zero))
                        }
                    }
                )

            case "Comment":
                .suppress

            case "Video":
                .rendered(
                    HTML.AnyView {
                        HTML.Video.Element {
                            HTML.Source.Element(
                                src: directive.arguments["source"].map(HTML.Src.Attribute.init)
                            )
                        }
                        .attribute("poster", directive.arguments["poster"])
                        .attribute("controls")
                        .attribute("playsinline")
                        .css
                        .objectFit(.cover)
                        .marginBottom(MarginBottom.rem(1))
                    }
                )

            default:
                .useDefault
            }
        }
    }

    public func adding(_ other: Markdown.Configuration.Directives) -> Self {
        Markdown.Configuration.Directives { directive in
            switch self.handler(directive) {
            case .useDefault:
                return other.handler(directive)

            case let result:
                return result
            }
        }
    }
}

extension Markdown.Configuration.Directives {

    public struct Directive: Sendable {
        public let name: String
        public let rawArguments: String
        public let arguments: [String: String]
        public let children: HTML.AnyView

        public init(
            name: String,
            rawArguments: String,
            arguments: [String: String],
            children: HTML.AnyView
        ) {
            self.name = name
            self.rawArguments = rawArguments
            self.arguments = arguments
            self.children = children
        }
    }
}

extension Markdown.Configuration.Directives.Directive {

    public enum Result: Sendable {

        case rendered(HTML.AnyView)

        case useDefault

        case suppress
    }
}
