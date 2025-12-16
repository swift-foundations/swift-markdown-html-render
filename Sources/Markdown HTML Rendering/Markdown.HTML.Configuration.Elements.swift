//
//  Markdown.HTML.Configuration.Elements.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering
@_spi(DynamicHTML) import HTML_Renderable
import CSS_HTML_Rendering
import CSS_Theming

extension Markdown.HTML.Configuration {
    /// Configuration for individual markdown element renderers.
    public struct Elements: Sendable {
        public var heading: Heading
        public var codeBlock: CodeBlock
        public var blockQuote: BlockQuote
        public var paragraph: Paragraph
        public var image: Image
        public var link: Link
        public var orderedList: List
        public var unorderedList: List
        public var listItem: ListItem
        public var table: Table
        public var thematicBreak: ThematicBreak
        public var emphasis: Emphasis
        public var strong: Strong
        public var strikethrough: Strikethrough
        public var inlineCode: InlineCode
        public var text: Text
        public var lineBreak: LineBreak
        public var softBreak: SoftBreak
        
        public init(
            heading: Heading = .default,
            codeBlock: CodeBlock = .default,
            blockQuote: BlockQuote = .default,
            paragraph: Paragraph = .default,
            image: Image = .default,
            link: Link = .default,
            orderedList: List = .defaultOrdered,
            unorderedList: List = .defaultUnordered,
            listItem: ListItem = .default,
            table: Table = .default,
            thematicBreak: ThematicBreak = .default,
            emphasis: Emphasis = .default,
            strong: Strong = .default,
            strikethrough: Strikethrough = .default,
            inlineCode: InlineCode = .default,
            text: Text = .default,
            lineBreak: LineBreak = .default,
            softBreak: SoftBreak = .default
        ) {
            self.heading = heading
            self.codeBlock = codeBlock
            self.blockQuote = blockQuote
            self.paragraph = paragraph
            self.image = image
            self.link = link
            self.orderedList = orderedList
            self.unorderedList = unorderedList
            self.listItem = listItem
            self.table = table
            self.thematicBreak = thematicBreak
            self.emphasis = emphasis
            self.strong = strong
            self.strikethrough = strikethrough
            self.inlineCode = inlineCode
            self.text = text
            self.lineBreak = lineBreak
            self.softBreak = softBreak
        }
    }
}

extension Markdown.HTML.Configuration.Elements {
    public static var `default`: Self { .init() }
}


// MARK: - Heading

extension Markdown.HTML.Configuration.Elements {
    public struct Heading: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView
        
        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements {
    public struct Input: Sendable {
        public let level: Int
        public let slug: String
        public let plainText: String
        public let children: HTML.AnyView
        
        public init(level: Int, slug: String, plainText: String, children: HTML.AnyView) {
            self.level = level
            self.slug = slug
            self.plainText = plainText
            self.children = children
        }
    }

}

extension Markdown.HTML.Configuration.Elements.Heading {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                Anchor() {}
                    .id(input.slug)
                    .css
                    .display(.block)
                    .position(.relative)
                    .top(Top.em(-5))
                    .desktop { $0.top(Top.em(-0.5)) }
                    .visibility(.hidden)
                
                ContentDivision {
                    tag("h\(input.level)") {
                        input.children
                        
                        Anchor(href: .init(value: "#\(input.slug)")) {
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
                    .css
                    .color(DarkModeColor.offBlack.withDarkColor(.offWhite))
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
        }
    }
}

// MARK: - CodeBlock

extension Markdown.HTML.Configuration.Elements {
    public struct CodeBlock: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView
        
        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.CodeBlock {
    public struct Input: Sendable {
        public let language: String?
        public let code: String
        public let highlightLines: String?
        
        public init(language: String?, code: String, highlightLines: String?) {
            self.language = language
            self.code = code
            self.highlightLines = highlightLines
        }
    }
}

extension Markdown.HTML.Configuration.Elements.CodeBlock {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                PreformattedText {
                    Code {
                        HTML.Text(input.code)
                    }
                    .attribute("class", input.language.map { "language-\($0)" })
                }
                .attribute("data-line", input.highlightLines)
                .css
                .color(DarkModeColor.text.primary)
                .margin(Margin.zero)
                .marginBottom(MarginBottom.rem(0.5))
                .overflowX(OverflowX.auto)
                .padding(Padding.sides(vertical: .rem(1), horizontal: .rem(1.5)))
                .borderRadius(BorderRadius.px(6))
            }
        }
    }
}

// MARK: - BlockQuote

extension Markdown.HTML.Configuration.Elements {
    public struct BlockQuote: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView
        
        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}
      
extension Markdown.HTML.Configuration.Elements.BlockQuote {
    public struct Input: Sendable {
        public let kind: String
        public let children: HTML.AnyView
        public let isDiagnostic: Bool
        public let diagnosticLevel: Diagnostic.Level?
        
        public init(kind: String, children: HTML.AnyView, isDiagnostic: Bool, diagnosticLevel: Diagnostic.Level?) {
            self.kind = kind
            self.children = children
            self.isDiagnostic = isDiagnostic
            self.diagnosticLevel = diagnosticLevel
        }
    }
}

extension Markdown.HTML.Configuration.Elements.BlockQuote {
    public static var `default`: Self {
        .init { input in
            if let level = input.diagnosticLevel {
                return HTML.AnyView {
                    Diagnostic(level: level) {
                        input.children
                    }
                    .css
                    .paddingLeft(PaddingLeft.rem(1))
                    .paddingRight(PaddingRight.rem(1))
                }
            } else {
                let style = SwiftMarkdown.BlockQuote.Style(blockName: input.kind)
                return HTML.AnyView {
                    HTML_Rendering.BlockQuote {
                        VStack(spacing: .rem(0.5)) {
                            StrongImportance {
                                HTML.Text(input.kind)
                            }
                            .css
                            .color(style.borderColor)
                            
                            input.children
                        }
                    }
                    .css
                    .color(DarkModeColor.offBlack)
                    .backgroundColor(style.backgroundColor)
                    .border(width: .px(2), style: .solid, color: style.borderColor)
                    .borderRadius(BorderRadius.uniform(.px(6)))
                    .margin(Margin.sides(vertical: .rem(0.5), horizontal: .zero))
                    .padding(Padding.sides(vertical: .rem(1), horizontal: .rem(1.5)))
                }
            }
        }
    }
}

// MARK: - Paragraph

extension Markdown.HTML.Configuration.Elements {
    public struct Paragraph: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView
        
        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}
       
extension Markdown.HTML.Configuration.Elements.Paragraph {
    public struct Input: Sendable {
        public let children: HTML.AnyView
        
        public init(children: HTML.AnyView) {
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Paragraph {
    
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                HTML_Rendering.Paragraph {
                    input.children
                }
                .css
                .lineHeight(1.5)
                .padding(Padding.zero)
                .margin(Margin.zero)
            }
        }
    }
}

// MARK: - Image

extension Markdown.HTML.Configuration.Elements {
    public struct Image: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Image {
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

extension Markdown.HTML.Configuration.Elements.Image {
    public static var `default`: Self {
        .init { input in
            guard let source = input.source else {
                return HTML.AnyView { HTML.Empty() }
            }
            return HTML.AnyView {
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

// MARK: - Link

extension Markdown.HTML.Configuration.Elements {
    public struct Link: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Link {
    public struct Input: Sendable {
        public let destination: String?
        public let title: String?
        public let children: HTML.AnyView

        public init(destination: String?, title: String?, children: HTML.AnyView) {
            self.destination = destination
            self.title = title
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Link {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                Anchor(href: .init(input.destination ?? "#")) {
                    input.children
                }
                .attribute(Title.tag, input.title)
            }
        }
    }
}

// MARK: - List

extension Markdown.HTML.Configuration.Elements {
    public struct List: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.List {
    public struct Input: Sendable {
        public let isOrdered: Bool
        public let children: HTML.AnyView

        public init(isOrdered: Bool, children: HTML.AnyView) {
            self.isOrdered = isOrdered
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.List {
    public static var defaultOrdered: Self {
        .init { input in
            HTML.AnyView {
                OrderedList {
                    input.children
                }
                .css
                .display(Display.flex)
                .flexDirection(FlexDirection.column)
                .rowGap(RowGap.length(.rem(0.5)))
            }
        }
    }

    public static var defaultUnordered: Self {
        .init { input in
            HTML.AnyView {
                UnorderedList {
                    input.children
                }
                .css
                .display(Display.flex)
                .flexDirection(FlexDirection.column)
                .rowGap(RowGap.length(.rem(0.5)))
                .marginTop(MarginTop.zero)
                .marginBottom(MarginBottom.zero)
            }
        }
    }
}

// MARK: - ListItem

extension Markdown.HTML.Configuration.Elements {
    public struct ListItem: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.ListItem {
    public struct Input: Sendable {
        public let children: HTML.AnyView

        public init(children: HTML.AnyView) {
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.ListItem {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                HTML_Rendering.ListItem {
                    VStack(spacing: .rem(0.5)) {
                        input.children
                    }
                }
            }
        }
    }
}

// MARK: - Table

extension Markdown.HTML.Configuration.Elements {
    public struct Table: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Table {
    public struct Input: Sendable {
        public let head: HTML.AnyView
        public let body: HTML.AnyView
        public let hasHead: Bool
        public let hasBody: Bool

        public init(head: HTML.AnyView, body: HTML.AnyView, hasHead: Bool, hasBody: Bool) {
            self.head = head
            self.body = body
            self.hasHead = hasHead
            self.hasBody = hasBody
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Table {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                HTML_Rendering.Table {
                    if input.hasHead {
                        TableHead {
                            TableRow {
                                input.head
                            }
                        }
                    }
                    if input.hasBody {
                        TableBody {
                            input.body
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ThematicBreak

extension Markdown.HTML.Configuration.Elements {
    public struct ThematicBreak: Sendable {
        public var render: @Sendable () -> HTML.AnyView

        public init(_ render: @escaping @Sendable () -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.ThematicBreak {
    public static var `default`: Self {
        .init {
            HTML.AnyView {
                ContentDivision {
                    HTML_Rendering.ThematicBreak()
                        .css
                        .borderRight(BorderRight.none)
                        .borderBottom(BorderBottom.none)
                        .borderLeft(BorderLeft.none)
                        .borderTop(.init(width: .px(1), style: .solid, color: .gray500))
                        .margin(Margin.sides(vertical: .zero, horizontal: .percent(30)))
                }
                .css
                .marginTop(MarginTop.rem(1))
                .marginBottom(MarginBottom.rem(2))
            }
        }
    }
}

// MARK: - Emphasis

extension Markdown.HTML.Configuration.Elements {
    public struct Emphasis: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Emphasis {
    public struct Input: Sendable {
        public let children: HTML.AnyView

        public init(children: HTML.AnyView) {
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Emphasis {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                HTML_Rendering.Emphasis {
                    input.children
                }
            }
        }
    }
}

// MARK: - Strong

extension Markdown.HTML.Configuration.Elements {
    public struct Strong: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Strong {
    public struct Input: Sendable {
        public let children: HTML.AnyView

        public init(children: HTML.AnyView) {
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Strong {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                StrongImportance {
                    input.children
                }
            }
        }
    }
}

// MARK: - Strikethrough

extension Markdown.HTML.Configuration.Elements {
    public struct Strikethrough: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Strikethrough {
    public struct Input: Sendable {
        public let children: HTML.AnyView

        public init(children: HTML.AnyView) {
            self.children = children
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Strikethrough {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                HTML_Rendering.Strikethrough {
                    input.children
                }
            }
        }
    }
}

// MARK: - InlineCode

extension Markdown.HTML.Configuration.Elements {
    public struct InlineCode: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.InlineCode {
    public struct Input: Sendable {
        public let code: String

        public init(code: String) {
            self.code = code
        }
    }
}

extension Markdown.HTML.Configuration.Elements.InlineCode {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                Code {
                    HTML.Text(input.code)
                }
            }
        }
    }
}

// MARK: - Text

extension Markdown.HTML.Configuration.Elements {
    public struct Text: Sendable {
        public var render: @Sendable (Input) -> HTML.AnyView

        public init(_ render: @escaping @Sendable (Input) -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Text {
    public struct Input: Sendable {
        public let text: String

        public init(text: String) {
            self.text = text
        }
    }
}

extension Markdown.HTML.Configuration.Elements.Text {
    public static var `default`: Self {
        .init { input in
            HTML.AnyView {
                HTML.Text(input.text)
            }
        }
    }
}

// MARK: - LineBreak

extension Markdown.HTML.Configuration.Elements {
    public struct LineBreak: Sendable {
        public var render: @Sendable () -> HTML.AnyView

        public init(_ render: @escaping @Sendable () -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.LineBreak {
    public static var `default`: Self {
        .init {
            HTML.AnyView {
                BR()
            }
        }
    }
}

// MARK: - SoftBreak

extension Markdown.HTML.Configuration.Elements {
    public struct SoftBreak: Sendable {
        public var render: @Sendable () -> HTML.AnyView

        public init(_ render: @escaping @Sendable () -> HTML.AnyView) {
            self.render = render
        }
    }
}

extension Markdown.HTML.Configuration.Elements.SoftBreak {
    public static var `default`: Self {
        .init {
            HTML.AnyView {
                " "
            }
        }
    }
}
