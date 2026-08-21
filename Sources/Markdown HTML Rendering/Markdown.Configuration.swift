import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown {

    public struct Configuration: Sendable {
        public var directives: Directives
        public var style: Style
        public var slugGenerator: SlugGenerator

        public init(
            directives: Directives = .default,
            style: Style = .default,
            slugGenerator: SlugGenerator = .default
        ) {
            self.directives = directives
            self.style = style
            self.slugGenerator = slugGenerator
        }
    }
}

extension Markdown.Configuration {
    public static var `default`: Self {
        .init(
            directives: .default,
            style: .default,
            slugGenerator: .default
        )
    }
}
