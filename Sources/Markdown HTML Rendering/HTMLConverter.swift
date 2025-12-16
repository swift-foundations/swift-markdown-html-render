//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering
@_spi(DynamicHTML) public import HTML_Renderable
import CSS_HTML_Rendering
import CSS_Theming

struct HTMLConverter: SwiftMarkdown.MarkupVisitor {
    typealias Result = HTML.AnyView

    let previewOnly: Bool

    init(previewOnly: Bool) {
        self.previewOnly = previewOnly
    }

    /// Extracts a named argument value from a BlockDirective.
    /// Parses argument text like `source: "video.mp4", poster: "thumb.jpg"`.
    private func value(forArgument name: String, block: SwiftMarkdown.BlockDirective) -> String? {
        let text = block.argumentText.segments.map(\.trimmedText).joined()
        // Find "name:" pattern
        guard let nameRange = text.range(of: "\(name):") ?? text.range(of: "\(name) :") else {
            return nil
        }
        var index = nameRange.upperBound
        // Skip whitespace
        while index < text.endIndex && text[index].isWhitespace {
            index = text.index(after: index)
        }
        guard index < text.endIndex else { return nil }

        let firstChar = text[index]
        if firstChar == "\"" || firstChar == "'" {
            // Quoted value
            let quote = firstChar
            index = text.index(after: index)
            let start = index
            while index < text.endIndex && text[index] != quote {
                index = text.index(after: index)
            }
            return String(text[start..<index])
        } else {
            // Unquoted value - read until comma or end
            let start = index
            while index < text.endIndex && text[index] != "," && !text[index].isWhitespace {
                index = text.index(after: index)
            }
            return String(text[start..<index])
        }
    }

    private var currentTimestamp: Timestamp?
    private var currentSection: (title: String, id: String, level: Int)?
    private var ids: Set<Slug> = []
    var tableOfContents: [Markdown.HTML.Section] = []

    @HTML.Builder
    mutating func defaultVisit(_ markup: any SwiftMarkdown.Markup) -> HTML.AnyView {
        for child in markup.children {
            let html = visit(child)
            if previewOnly ? tableOfContents.count <= 1 : true {
                html
            }
        }
    }

    @HTML.Builder
    mutating func visitBlockDirective(_ blockDirective: SwiftMarkdown.BlockDirective) -> HTML.AnyView {
        switch blockDirective.name {
        case "Button":
            VStack(alignment: .center) {
                Anchor(
                    href: .init(
                        blockDirective.argumentText.segments.map(\.trimmedText).joined(
                            separator: " "
                        )
                    )
                ) {
                    for child in blockDirective.children {
                        visit(child)
                    }
                }
                .css
                .margin(Margin.sides(vertical: .rem(0.5), horizontal: .zero))
            }

        case "Comment":
            HTML.Empty()

        case "T":
            let segments = blockDirective.argumentText.segments
                .map(\.trimmedText)
                .joined()
                .split(separator: ", ")

            if let segment = segments.first {
                let timestamp = Timestamp(
                    format: String(segment),
                    speaker: segments.dropFirst().first.map { String($0) }
                )
                let _ = currentTimestamp = timestamp
                timestamp
                if let currentSection {
                    let _ = tableOfContents.append(
                        Markdown.HTML.Section(
                            title: currentSection.title,
                            id: currentSection.id,
                            level: currentSection.level,
                            timestamp: timestamp
                        )
                    )
                    let _ = self.currentSection = nil
                }
            }

        case "Video":
            Video() {
                Source(src: value(forArgument: "source", block: blockDirective).map(Src.init))
            }
            .attribute("poster", value(forArgument: "poster", block: blockDirective))
            .attribute("controls")
            .attribute("playsinline")
            .css
            .objectFit(.cover)
            .marginBottom(MarginBottom.rem(1))

        default:
            for child in blockDirective.children {
                visit(child)
            }
        }
    }

    @HTML.Builder
    mutating func visitBlockQuote(_ blockQuote: SwiftMarkdown.BlockQuote) -> HTML.AnyView {
        let aside = SwiftMarkdown.Aside(blockQuote)
        if let level = Diagnostic.Level(aside: aside) {
            Diagnostic(level: level) {
                for child in aside.content {
                    visit(child)
                }
            }
            .css
            .paddingLeft(PaddingLeft.rem(1))
            .paddingRight(PaddingRight.rem(1))
        } else {
            let style = BlockQuote.Style(blockName: aside.kind.displayName)
            BlockQuote() {
                VStack(spacing: .rem(0.5)) {
                    StrongImportance() {
                        HTML.Text(aside.kind.displayName)
                    }
                    .css
                    .color(style.borderColor)

                    for child in aside.content {
                        visit(child)
                    }
                }
            }
            .css
            .color(HTMLColor.offBlack)
            .backgroundColor(style.backgroundColor)
            .border(width: .px(2), style: .solid, color: style.borderColor)
            .borderRadius(BorderRadius.uniform(.px(6)))
            .margin(Margin.sides(vertical: .rem(0.5), horizontal: .zero))
            .padding(Padding.sides(vertical: .rem(1), horizontal: .rem(1.5)))
        }
    }

    @HTML.Builder
    mutating func visitCodeBlock(_ codeBlock: SwiftMarkdown.CodeBlock) -> HTML.AnyView {
        let language: (class: String, dataLine: String?)? = codeBlock.language.map {
            let languageInfo = $0.split(separator: ":", maxSplits: 2)
            let language = languageInfo[0]
            let dataLine = languageInfo.dropFirst().first
            let highlightColor = languageInfo.dropFirst(2).first
            return (
                class: "language-\(language)\(highlightColor.map { " highlight-\($0)" } ?? "")",
                dataLine: dataLine.map { String($0) }
            )
        }
        PreformattedText() {
            Code() {
                HTML.Text(codeBlock.code)
            }
            .attribute("class", language?.class)
            //            .linkUnderline(true)
        }
        .attribute("data-line", language?.dataLine)
        //        .backgroundColor(.offWhite.withDarkColor(.offBlack))
        .css
        .color(HTMLColor.text.primary)
        .margin(Margin.zero)
        .marginBottom(MarginBottom.rem(0.5))
        .overflowX(OverflowX.auto)
        .padding(Padding.sides(vertical: .rem(1), horizontal: .rem(1.5)))
        .borderRadius(BorderRadius.px(6))
    }

    @HTML.Builder
    mutating func visitEmphasis(_ emphasis: SwiftMarkdown.Emphasis) -> HTML.AnyView {
        Emphasis() {
            for child in emphasis.children {
                visit(child)
            }
        }
    }

    @HTML.Builder
    mutating func visitHeading(_ heading: SwiftMarkdown.Heading) -> HTML.AnyView {
        let id = ids.slug(for: heading.plainText)

        Anchor() {}
            .id(id)
            .css
            .display(.block)
            .position(.relative)
            .top(Top.em(-5))
            .desktop { $0.top(Top.em(-0.5)) }
            .visibility(.hidden)

        ContentDivision() {
            tag("h\(heading.level)") {
                for child in heading.children {
                    visit(child)
                }

                Anchor(href: .init(value: "#\(id)")) {
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

        let _ = currentSection = (title: heading.plainText, id: id, level: heading.level)
    }

    @HTML.Builder
    mutating func visitHTMLBlock(_ html: SwiftMarkdown.HTMLBlock) -> HTML.AnyView {
        HTML.Raw(html.rawHTML)
    }

    @HTML.Builder
    mutating func visitImage(_ image: SwiftMarkdown.Image) -> HTML.AnyView {
        if let source = image.source {
            VStack(alignment: .center) {
                Anchor(href: .init(value: source)) {
                    Image(
                        src: .init(value: source),
                        alt: .init(value: image.title ?? "")
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

    @HTML.Builder
    mutating func visitInlineCode(_ inlineCode: SwiftMarkdown.InlineCode) -> HTML.AnyView {
        Code() {
            HTML.Text(inlineCode.code)
        }
    }

    @HTML.Builder
    mutating func visitInlineHTML(_ inlineHTML: SwiftMarkdown.InlineHTML) -> HTML.AnyView {
        HTML.Raw(inlineHTML.rawHTML)
    }

    @HTML.Builder
    mutating func visitLineBreak(_ lineBreak: SwiftMarkdown.LineBreak) -> HTML.AnyView {
        BR()
    }

    @HTML.Builder
    mutating func visitLink(_ link: SwiftMarkdown.Link) -> HTML.AnyView {
        Anchor(href: .init(link.destination ?? "#")) {
            for child in link.children {
                visit(child)
            }
        }
        .attribute(Title.tag, link.title)
    }

    @HTML.Builder
    mutating func visitListItem(_ listItem: SwiftMarkdown.ListItem) -> HTML.AnyView {
        ListItem() {
            VStack(spacing: .rem(0.5)) {
                for child in listItem.children {
                    visit(child)
                }
            }
        }
    }

    @HTML.Builder
    mutating func visitOrderedList(_ orderedList: SwiftMarkdown.OrderedList) -> HTML.AnyView {
        OrderedList() {
            for child in orderedList.children {
                visit(child)
            }
        }
        .css
        .display(Display.flex)
        .flexDirection(FlexDirection.column)
        .rowGap(RowGap.length(.rem(0.5)))
    }

    @HTML.Builder
    mutating func visitParagraph(_ paragraph: SwiftMarkdown.Paragraph) -> HTML.AnyView {
        Paragraph() {
            for child in paragraph.children {
                visit(child)
            }
        }
        .css
        .lineHeight(1.5)
        .padding(Padding.zero)
        .margin(Margin.zero)
    }

    @HTML.Builder
    mutating func visitSoftBreak(_ softBreak: SwiftMarkdown.SoftBreak) -> HTML.AnyView {
        " "
    }

    @HTML.Builder
    mutating func visitStrikethrough(_ strikethrough: SwiftMarkdown.Strikethrough) -> HTML.AnyView {
        Strikethrough() {
            for child in strikethrough.children {
                visit(child)
            }
        }
    }

    @HTML.Builder
    mutating func visitStrong(_ strong: SwiftMarkdown.Strong) -> HTML.AnyView {
        StrongImportance() {
            for child in strong.children {
                visit(child)
            }
        }
    }

    @HTML.Builder
    mutating func visitTable(_ table: SwiftMarkdown.Table) -> HTML.AnyView {
        Table() {
            if !table.head.isEmpty {
                TableHead() {
                    TableRow() {
                        render(
                            tagName: "th",
                            cells: table.head.cells,
                            columnAlignments: table.columnAlignments
                        )
                    }
                }
            }
            if !table.body.isEmpty {
                TableBody() {
                    HTMLForEach(table.body.rows) { row in
                        TableRow() {
                            render(
                                tagName: "td",
                                cells: row.cells,
                                columnAlignments: table.columnAlignments
                            )
                        }
                    }
                    //                    for row in table.body.rows {
                    //                        TableRow() {
                    //                            render(tag: "td", cells: row.cells, columnAlignments: table.columnAlignments)
                    //                        }
                    //                    }
                }
            }
        }
    }

    @HTML.Builder
    private mutating func render(
        tagName: String,
        cells: some Sequence<SwiftMarkdown.Table.Cell>,
        columnAlignments: [SwiftMarkdown.Table.ColumnAlignment?]
    ) -> HTML.AnyView {
        var column = 0
        for cell in cells {
            if cell.colspan > 0 && cell.rowspan > 0 {
                tag(tagName) {
                    for child in cell.children {
                        visit(child)
                    }
                }
                .attribute("align", columnAlignments[column]?.attributeValue)
                .attribute("colspan", cell.colspan == 1 ? nil : "\(cell.colspan)")
                .attribute("rowspan", cell.rowspan == 1 ? nil : "\(cell.rowspan)")

                let _ = column += Int(cell.colspan)
            }
        }
    }

    @HTML.Builder
    mutating func visitText(_ text: SwiftMarkdown.Text) -> HTML.AnyView {
        HTML.Text(text.string)
    }

    @HTML.Builder
    mutating func visitThematicBreak(_ thematicBreak: SwiftMarkdown.ThematicBreak) -> HTML.AnyView {
        ContentDivision() {
            ThematicBreak()
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

    @HTML.Builder
    mutating func visitUnorderedList(_ unorderedList: SwiftMarkdown.UnorderedList) -> HTML.AnyView {
        UnorderedList() {
            for child in unorderedList.children {
                visit(child)
            }
        }
        .css
        .display(Display.flex)
        .flexDirection(FlexDirection.column)
        .rowGap(RowGap.length(.rem(0.5)))
        .marginTop(MarginTop.zero)
        .marginBottom(MarginBottom.zero)
    }
}

extension SwiftMarkdown.Table.ColumnAlignment {
    fileprivate var attributeValue: String {
        switch self {
        case .center: "center"
        case .left: "left"
        case .right: "right"
        }
    }
}
