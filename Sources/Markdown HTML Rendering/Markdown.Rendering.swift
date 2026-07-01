import CSS_HTML_Rendering
import CSS_Theming
@_spi(DynamicHTML) import HTML_Rendering_Core
import HTML_Rendering
public import Render_Primitives
import Ownership_Mutable_Primitives

extension Markdown {
    /// Action-based element renderers for direct markdown rendering.
    ///
    /// Each closure receives pre-rendered children as ``Render.Action`` arrays
    /// and returns the complete action sequence for the element, with O(1) stack
    /// depth interpretation.
    public struct Rendering: Sendable {
        /// Bridge to the L1 ``Render.Action`` type, avoiding name shadowing
        /// in nested extensions where `Rendering` resolves to `Markdown.Rendering`.
        public typealias Action = Render_Primitives.Render.Action

        public var heading: Heading
        public var paragraph: Paragraph
        public var codeBlock: CodeBlock
        public var blockQuote: BlockQuote
        public var emphasis: Emphasis
        public var strong: Strong
        public var strikethrough: Strikethrough
        public var inlineCode: InlineCode
        public var link: Link
        public var image: Image
        public var orderedList: List
        public var unorderedList: List
        public var listItem: ListItem
        public var table: Table
        public var text: Text
        public var thematicBreak: ThematicBreak
        public var lineBreak: LineBreak
        public var softBreak: SoftBreak

        public init(
            heading: Heading = .default,
            paragraph: Paragraph = .default,
            codeBlock: CodeBlock = .default,
            blockQuote: BlockQuote = .default,
            emphasis: Emphasis = .default,
            strong: Strong = .default,
            strikethrough: Strikethrough = .default,
            inlineCode: InlineCode = .default,
            link: Link = .default,
            image: Image = .default,
            orderedList: List = .defaultOrdered,
            unorderedList: List = .defaultUnordered,
            listItem: ListItem = .default,
            table: Table = .default,
            text: Text = .default,
            thematicBreak: ThematicBreak = .default,
            lineBreak: LineBreak = .default,
            softBreak: SoftBreak = .default
        ) {
            self.heading = heading
            self.paragraph = paragraph
            self.codeBlock = codeBlock
            self.blockQuote = blockQuote
            self.emphasis = emphasis
            self.strong = strong
            self.strikethrough = strikethrough
            self.inlineCode = inlineCode
            self.link = link
            self.image = image
            self.orderedList = orderedList
            self.unorderedList = unorderedList
            self.listItem = listItem
            self.table = table
            self.text = text
            self.thematicBreak = thematicBreak
            self.lineBreak = lineBreak
            self.softBreak = softBreak
        }
    }
}

extension Markdown.Rendering {
    public static var `default`: Self { .init() }
}

// MARK: - Capture Helper

extension Markdown.Rendering {
    /// Renders an HTML view tree through a capturing context, producing actions.
    ///
    /// This bridges the existing HTML view infrastructure to the action-based
    /// rendering pipeline. CSS styles, attributes, and element structure are
    /// faithfully captured as ``Render.Action`` values.
    static func capture<V: HTML.View>(
        @HTML.Builder _ content: () -> V
    ) -> [Action] {
        let buffer = Ownership.Mutable<[Render_Primitives.Render.Action]>([])
        var ctx = Render_Primitives.Render.Context.capturing(into: buffer)
        ctx.render(content())
        return buffer.value
    }
}
