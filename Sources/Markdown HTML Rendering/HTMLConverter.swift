//
//  HTMLConverter.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import CSS_HTML_Rendering
import CSS_Theming
@_spi(DynamicHTML) import HTML_Renderable
import HTML_Rendering

struct HTMLConverter: SwiftMarkdown.MarkupVisitor {
    typealias Result = HTML.AnyView

    let configuration: Markdown.HTML.Configuration
    let previewOnly: Bool

    init(configuration: Markdown.HTML.Configuration, previewOnly: Bool) {
        self.configuration = configuration
        self.previewOnly = previewOnly
    }

    private var currentTimestamp: Timestamp?
    private var currentSection: (title: String, id: String, level: Int)?
    private var existingSlugs: Set<String> = []
    var tableOfContents: [Markdown.HTML.Section] = []

    /// Extracts a named argument value from a BlockDirective.
    private func value(forArgument name: String, block: SwiftMarkdown.BlockDirective) -> String? {
        let text = block.argumentText.segments.map(\.trimmedText).joined()
        guard let nameRange = text.range(of: "\(name):") ?? text.range(of: "\(name) :") else {
            return nil
        }
        var index = nameRange.upperBound
        while index < text.endIndex && text[index].isWhitespace {
            index = text.index(after: index)
        }
        guard index < text.endIndex else { return nil }

        let firstChar = text[index]
        if firstChar == "\"" || firstChar == "'" {
            let quote = firstChar
            index = text.index(after: index)
            let start = index
            while index < text.endIndex && text[index] != quote {
                index = text.index(after: index)
            }
            return String(text[start..<index])
        } else {
            let start = index
            while index < text.endIndex && text[index] != "," && !text[index].isWhitespace {
                index = text.index(after: index)
            }
            return String(text[start..<index])
        }
    }

    /// Parse arguments from a block directive into a dictionary.
    private func parseArguments(from block: SwiftMarkdown.BlockDirective) -> [String: String] {
        var result: [String: String] = [:]
        let text = block.argumentText.segments.map(\.trimmedText).joined()

        // Simple parser for key: "value" or key: value patterns
        var remaining = text[...]
        while !remaining.isEmpty {
            // Skip whitespace and commas
            remaining = remaining.drop { $0.isWhitespace || $0 == "," }
            guard !remaining.isEmpty else { break }

            // Find key
            guard let colonIndex = remaining.firstIndex(of: ":") else { break }
            let key = String(remaining[..<colonIndex]).trimmingCharacters(in: .whitespaces)
            remaining = remaining[remaining.index(after: colonIndex)...]

            // Skip whitespace after colon
            remaining = remaining.drop { $0.isWhitespace }
            guard !remaining.isEmpty else { break }

            // Parse value
            let firstChar = remaining.first!
            if firstChar == "\"" || firstChar == "'" {
                let quote = firstChar
                remaining = remaining.dropFirst()
                if let endQuote = remaining.firstIndex(of: quote) {
                    result[key] = String(remaining[..<endQuote])
                    remaining = remaining[remaining.index(after: endQuote)...]
                }
            } else {
                let endIndex =
                    remaining.firstIndex { $0 == "," || $0.isWhitespace } ?? remaining.endIndex
                result[key] = String(remaining[..<endIndex])
                remaining = remaining[endIndex...]
            }
        }

        return result
    }

    private mutating func generateSlug(for text: String) -> String {
        let slug = configuration.slugGenerator.generate(
            .init(text: text, existingSlugs: existingSlugs)
        )
        existingSlugs.insert(slug)
        return slug
    }

    @HTML.Builder
    mutating func defaultVisit(_ markup: any SwiftMarkdown.Markup) -> HTML.AnyView {
        for child in markup.children {
            let html = visit(child)
            if previewOnly ? tableOfContents.count <= 1 : true {
                html
            }
        }
    }

    mutating func visitBlockDirective(
        _ blockDirective: SwiftMarkdown.BlockDirective
    ) -> HTML.AnyView {
        // First, check if it's a timestamp directive (handled specially)
        if blockDirective.name == "T" {
            let segments = blockDirective.argumentText.segments
                .map(\.trimmedText)
                .joined()
                .split(separator: ", ")

            if let segment = segments.first {
                let timestamp = Timestamp(
                    format: String(segment),
                    speaker: segments.dropFirst().first.map { String($0) }
                )
                currentTimestamp = timestamp
                if let currentSection {
                    tableOfContents.append(
                        Markdown.HTML.Section(
                            title: currentSection.title,
                            id: currentSection.id,
                            level: currentSection.level,
                            timestamp: timestamp
                        )
                    )
                    self.currentSection = nil
                }
                return HTML.AnyView { timestamp }
            }
            return HTML.AnyView { HTML.Empty() }
        }

        // Build children HTML
        var mutableSelf = self
        let childrenHTML = HTML.AnyView {
            for child in blockDirective.children {
                mutableSelf.visit(child)
            }
        }
        self = mutableSelf

        let directive = Markdown.HTML.Configuration.Directives.Directive(
            name: blockDirective.name,
            rawArguments: blockDirective.argumentText.segments.map(\.trimmedText).joined(
                separator: " "
            ),
            arguments: parseArguments(from: blockDirective),
            children: childrenHTML
        )

        let result = configuration.directives.handler(directive)

        switch result {
        case .rendered(let view):
            return view
        case .suppress:
            return HTML.AnyView { HTML.Empty() }
        case .useDefault:
            return childrenHTML
        }
    }

    @HTML.Builder
    mutating func visitBlockQuote(_ blockQuote: SwiftMarkdown.BlockQuote) -> HTML.AnyView {
        let aside = SwiftMarkdown.Aside(blockQuote)
        let kind = aside.kind.displayName

        // Check for diagnostic level
        let diagnosticLevel = configuration.style.diagnostic.level(aside.kind.rawValue)

        let childrenHTML = HTML.AnyView {
            for child in aside.content {
                visit(child)
            }
        }

        configuration.elements.blockQuote.render(
            .init(
                kind: kind,
                children: childrenHTML,
                isDiagnostic: diagnosticLevel != nil,
                diagnosticLevel: diagnosticLevel
            )
        )
    }

    mutating func visitCodeBlock(_ codeBlock: SwiftMarkdown.CodeBlock) -> HTML.AnyView {
        let languageInfo: (language: String?, highlightLines: String?)
        if let lang = codeBlock.language {
            let parts = lang.split(separator: ":", maxSplits: 2)
            languageInfo = (
                language: parts.first.map(String.init),
                highlightLines: parts.dropFirst().first.map(String.init)
            )
        } else {
            languageInfo = (nil, nil)
        }

        return configuration.elements.codeBlock.render(
            .init(
                language: languageInfo.language,
                code: codeBlock.code,
                highlightLines: languageInfo.highlightLines
            )
        )
    }

    @HTML.Builder
    mutating func visitEmphasis(_ emphasis: SwiftMarkdown.Emphasis) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in emphasis.children {
                visit(child)
            }
        }
        configuration.elements.emphasis.render(.init(children: childrenHTML))
    }

    @HTML.Builder
    mutating func visitHeading(_ heading: SwiftMarkdown.Heading) -> HTML.AnyView {
        let slug = generateSlug(for: heading.plainText)

        let childrenHTML = HTML.AnyView {
            for child in heading.children {
                visit(child)
            }
        }

        let _ = currentSection = (title: heading.plainText, id: slug, level: heading.level)

        configuration.elements.heading.render(
            .init(
                level: heading.level,
                slug: slug,
                plainText: heading.plainText,
                children: childrenHTML
            )
        )
    }

    @HTML.Builder
    mutating func visitHTMLBlock(_ html: SwiftMarkdown.HTMLBlock) -> HTML.AnyView {
        HTML.Raw(html.rawHTML)
    }

    @HTML.Builder
    mutating func visitImage(_ image: SwiftMarkdown.Image) -> HTML.AnyView {
        configuration.elements.image.render(
            .init(
                source: image.source,
                alt: image.plainText,
                title: image.title
            )
        )
    }

    @HTML.Builder
    mutating func visitInlineCode(_ inlineCode: SwiftMarkdown.InlineCode) -> HTML.AnyView {
        configuration.elements.inlineCode.render(.init(code: inlineCode.code))
    }

    @HTML.Builder
    mutating func visitInlineHTML(_ inlineHTML: SwiftMarkdown.InlineHTML) -> HTML.AnyView {
        HTML.Raw(inlineHTML.rawHTML)
    }

    @HTML.Builder
    mutating func visitLineBreak(_ lineBreak: SwiftMarkdown.LineBreak) -> HTML.AnyView {
        configuration.elements.lineBreak.render()
    }

    @HTML.Builder
    mutating func visitLink(_ link: SwiftMarkdown.Link) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in link.children {
                visit(child)
            }
        }
        configuration.elements.link.render(
            .init(
                destination: link.destination,
                title: link.title,
                children: childrenHTML
            )
        )
    }

    @HTML.Builder
    mutating func visitListItem(_ listItem: SwiftMarkdown.ListItem) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in listItem.children {
                visit(child)
            }
        }
        configuration.elements.listItem.render(.init(children: childrenHTML))
    }

    @HTML.Builder
    mutating func visitOrderedList(_ orderedList: SwiftMarkdown.OrderedList) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in orderedList.children {
                visit(child)
            }
        }
        configuration.elements.orderedList.render(.init(isOrdered: true, children: childrenHTML))
    }

    @HTML.Builder
    mutating func visitParagraph(_ paragraph: SwiftMarkdown.Paragraph) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in paragraph.children {
                visit(child)
            }
        }
        configuration.elements.paragraph.render(.init(children: childrenHTML))
    }

    @HTML.Builder
    mutating func visitSoftBreak(_ softBreak: SwiftMarkdown.SoftBreak) -> HTML.AnyView {
        configuration.elements.softBreak.render()
    }

    @HTML.Builder
    mutating func visitStrikethrough(_ strikethrough: SwiftMarkdown.Strikethrough) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in strikethrough.children {
                visit(child)
            }
        }
        configuration.elements.strikethrough.render(.init(children: childrenHTML))
    }

    @HTML.Builder
    mutating func visitStrong(_ strong: SwiftMarkdown.Strong) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in strong.children {
                visit(child)
            }
        }
        configuration.elements.strong.render(.init(children: childrenHTML))
    }

    @HTML.Builder
    mutating func visitTable(_ table: SwiftMarkdown.Table) -> HTML.AnyView {
        let headHTML = HTML.AnyView {
            render(
                tagName: "th",
                cells: table.head.cells,
                columnAlignments: table.columnAlignments
            )
        }

        let bodyHTML = HTML.AnyView {
            HTMLForEach(table.body.rows) { row in
                TableRow {
                    render(
                        tagName: "td",
                        cells: row.cells,
                        columnAlignments: table.columnAlignments
                    )
                }
            }
        }

        configuration.elements.table.render(
            .init(
                head: headHTML,
                body: bodyHTML,
                hasHead: !table.head.isEmpty,
                hasBody: !table.body.isEmpty
            )
        )
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
        configuration.elements.text.render(.init(text: text.string))
    }

    @HTML.Builder
    mutating func visitThematicBreak(_ thematicBreak: SwiftMarkdown.ThematicBreak) -> HTML.AnyView {
        configuration.elements.thematicBreak.render()
    }

    @HTML.Builder
    mutating func visitUnorderedList(_ unorderedList: SwiftMarkdown.UnorderedList) -> HTML.AnyView {
        let childrenHTML = HTML.AnyView {
            for child in unorderedList.children {
                visit(child)
            }
        }
        configuration.elements.unorderedList.render(.init(isOrdered: false, children: childrenHTML))
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
