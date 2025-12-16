//
//  Markdown.HTML.Configuration.Directives.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.HTML.Configuration {
    /// Configuration for handling block directives in markdown.
    ///
    /// Block directives are special markdown syntax like `@Button`, `@Video`, etc.
    /// Use this to add custom directive handlers or override built-in ones.
    ///
    /// Example:
    /// ```swift
    /// let customDirectives = Markdown.HTML.Configuration.Directives { directive in
    ///     switch directive.name {
    ///     case "Alert":
    ///         .rendered(MyAlert(type: directive.arguments["type"]) {
    ///             directive.children
    ///         })
    ///     default:
    ///         .useDefault
    ///     }
    /// }
    /// ```
    public struct Directives: Sendable {
        public var handler:
            @Sendable (Directive) -> Markdown.HTML.Configuration.Directives.Directive.Result

        public init(
            _ handler:
                @escaping @Sendable (Directive) ->
                Markdown.HTML.Configuration.Directives.Directive.Result
        ) {
            self.handler = handler
        }
    }
}

extension Markdown.HTML.Configuration.Directives {
    public static var `default`: Self {
        .init { directive in
            switch directive.name {
            case "Button":
                .rendered(
                    HTML.AnyView {
                        VStack(alignment: .center) {
                            Anchor(href: .init(directive.rawArguments)) {
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
                        Video {
                            Source(src: directive.arguments["source"].map(Src.init))
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

    /// Combine multiple directive handlers.
    /// The first handler that doesn't return `.useDefault` wins.
    public func adding(_ other: Markdown.HTML.Configuration.Directives) -> Self {
        Markdown.HTML.Configuration.Directives { directive in
            switch self.handler(directive) {
            case .useDefault:
                return other.handler(directive)
            case let result:
                return result
            }
        }
    }
}

extension Markdown.HTML.Configuration.Directives {
    /// Input for a block directive.
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

extension Markdown.HTML.Configuration.Directives.Directive {
    /// Result of handling a directive.
    public enum Result: Sendable {
        /// Use this rendered view
        case rendered(HTML.AnyView)
        /// Fall back to built-in or next handler
        case useDefault
        /// Render nothing (suppress the directive)
        case suppress
    }
}
