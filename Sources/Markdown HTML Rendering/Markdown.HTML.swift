import CSS_HTML_Rendering
import CSS_Theming
@_spi(DynamicHTML) public import HTML_Renderable
import HTML_Rendering

public enum Markdown {}

extension Markdown {
    public struct HTML {
        public let configuration: Configuration
        public let previewOnly: Bool

        public init(
            configuration: Configuration = .default,
            previewOnly: Bool = false
        ) {
            self.configuration = configuration
            self.previewOnly = previewOnly
        }
    }
}

extension Markdown.HTML {
    public func callAsFunction(
        @Markdown.HTML.Builder _ markdown: () -> String
    ) -> some HTML_Renderable.HTML.View {
        let markdownString = markdown()
        var converter = HTMLConverter(configuration: configuration, previewOnly: previewOnly)
        let content = converter.visit(
            SwiftMarkdown.Document(parsing: markdownString, options: .parseBlockDirectives)
        )

        return ContentDivision {
            VStack(spacing: .rem(0.5)) {
                content
            }
            .css
            .inlineStyle(
                "mask-image",
                previewOnly ? "linear-gradient(to bottom,black 50%,transparent 100%)" : nil
            )
        }
        .css
        .display(.block)
    }

    public static func tableOfContents(
        from markdown: String,
        configuration: Configuration = .default
    ) -> [Section] {
        var converter = HTMLConverter(configuration: configuration, previewOnly: false)
        _ = converter.visit(
            SwiftMarkdown.Document(parsing: markdown, options: .parseBlockDirectives)
        )
        return converter.tableOfContents
    }
}

extension Markdown.HTML {
    public struct Section {
        public let title: String
        public let id: String
        public let level: Int
        public let timestamp: Timestamp?

        public var anchor: String {
            "#\(id)"
        }

        public init(title: String, id: String, level: Int, timestamp: Timestamp?) {
            self.title = title
            self.id = id
            self.level = level
            self.timestamp = timestamp
        }
    }
}
