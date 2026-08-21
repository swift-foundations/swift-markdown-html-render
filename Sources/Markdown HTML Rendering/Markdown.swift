import CSS_HTML_Layout_Rendering
import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering
@_spi(DynamicHTML) public import HTML_Rendering_Core
import Render_Primitives

public struct Markdown: HTML_Rendering_Core.HTML.View {
    let markdownString: String
    let configuration: Configuration
    let rendering: Rendering
    let previewOnly: Bool

    public init(
        configuration: Configuration = .default,
        rendering: Rendering = .default,
        previewOnly: Bool = false,
        @Markdown.Builder _ markdown: () -> String
    ) {
        self.configuration = configuration
        self.rendering = rendering
        self.previewOnly = previewOnly
        self.markdownString = markdown()
    }
}

extension Markdown {
    public var body: some HTML.View { HTML.Empty() }

    private static let outerFrame = Rendering.Frame {
        HTML.ContentDivision.Element {
            VStack(spacing: .rem(0.5)) {
                Rendering.Frame.Placeholder()
            }
        }
        .css
        .display(.block)
    }

    private static let outerFramePreview = Rendering.Frame {
        HTML.ContentDivision.Element {
            VStack(spacing: .rem(0.5)) {
                Rendering.Frame.Placeholder()
            }
            .css
            .inlineStyle(
                "mask-image",
                "linear-gradient(to bottom,black 50%,transparent 100%)"
            )
        }
        .css
        .display(.block)
    }

    public static func _render(
        _ view: borrowing Self,
        context: inout Render_Primitives.Render.Context
    ) {
        let document = SwiftMarkdown.Document(
            parsing: view.markdownString,
            options: .parseBlockDirectives
        )

        var converter = Rendering.Converter(
            rendering: view.rendering,
            configuration: view.configuration,
            previewOnly: view.previewOnly
        )
        let contentActions = converter.visit(document)

        let frame = view.previewOnly ? Self.outerFramePreview : Self.outerFrame
        context.interpret(markdown: frame.applying(children: contentActions))
    }
}

extension Markdown {
    public static func tableOfContents(
        from markdown: String,
        configuration: Configuration = .default,
        rendering: Rendering = .default
    ) -> [Section] {
        var converter = Rendering.Converter(
            rendering: rendering,
            configuration: configuration,
            previewOnly: false
        )
        _ = converter.visit(
            SwiftMarkdown.Document(parsing: markdown, options: .parseBlockDirectives)
        )
        return converter.tableOfContents
    }
}

extension Markdown {
    public struct Section {
        public let title: String
        public let id: String
        public let level: Int
        public let timestamp: Timestamp?

        public init(title: String, id: String, level: Int, timestamp: Timestamp?) {
            self.title = title
            self.id = id
            self.level = level
            self.timestamp = timestamp
        }
    }
}

extension Markdown.Section {
    public var anchor: String {
        "#\(id)"
    }
}
