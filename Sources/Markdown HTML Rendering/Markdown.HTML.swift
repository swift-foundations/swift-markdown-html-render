import HTML_Rendering
@_spi(DynamicHTML) public import HTML_Renderable
import CSS_HTML_Rendering
import CSS_Theming

public enum Markdown {}

extension Markdown {
    public struct HTML {
        public let previewOnly: Bool
        
        public init(previewOnly: Bool = false) {
            self.previewOnly = previewOnly
        }
    }
}

extension Markdown.HTML {
    public func callAsFunction(
        @Markdown.HTML.Builder _ markdown: () -> String
    ) -> some HTML_Renderable.HTML.View {
        let markdownString = markdown()
        var converter = HTMLConverter(previewOnly: previewOnly)
        let content = converter.visit(SwiftMarkdown.Document(parsing: markdownString, options: .parseBlockDirectives))
        
        return ContentDivision() {
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
    
    public static func tableOfContents(from markdown: String) -> [Section] {
        var converter = HTMLConverter(previewOnly: false)
        _ = converter.visit(SwiftMarkdown.Document(parsing: markdown, options: .parseBlockDirectives))
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
