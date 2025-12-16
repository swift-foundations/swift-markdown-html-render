import HTML_Rendering
@_spi(DynamicHTML) public import HTML_Renderable
import CSS_HTML_Rendering
import CSS_Theming
import Markdown

public typealias MarkdownDocument = Markdown.Document

extension HTML {
    public struct Markdown {
        public let markdown: String
        public let previewOnly: Bool
        public let tableOfContents: [Section]
        public let content: HTML.AnyView

        public init(_ markdown: String, previewOnly: Bool = false) {
            self.markdown = markdown
            self.previewOnly = previewOnly
            var converter = HTMLConverter(previewOnly: previewOnly)
            self.content = converter.visit(MarkdownDocument(parsing: markdown, options: .parseBlockDirectives))
            self.tableOfContents = converter.tableOfContents
        }
    }
}

extension HTML.Markdown: HTML.View {
    public var body: some HTML.View {
        ContentDivision() {
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
}

extension HTML.Markdown {
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

func value(forArgument argument: String, block: BlockDirective) -> String? {
    block.argumentText.segments
        .compactMap {
            let text = $0.trimmedText.drop(while: { $0 == " " })
            return text.hasPrefix("\(argument): \"")
                ? text.dropFirst("\(argument): \"".count).prefix(while: { $0 != "\"" })
                : nil
        }
        .first
        .map(String.init)
}





