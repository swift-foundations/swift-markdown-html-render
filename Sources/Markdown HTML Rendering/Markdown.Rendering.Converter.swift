import CSS_HTML_Rendering
import CSS_Theming
import Foundation
@_spi(DynamicHTML) import HTML_Rendering_Core
import HTML_Rendering
import Render_Primitives

extension Markdown.Rendering {
    /// A ``SwiftMarkdown.MarkupVisitor`` that produces ``Render.Action`` arrays
    /// instead of ``HTML.AnyView`` trees.
    ///
    /// This flattens the rendering stack from O(view tree depth) to O(1),
    /// eliminating the stack overflow caused by deeply nested `AnyView` trees.
    struct Converter: SwiftMarkdown.MarkupVisitor {
        typealias Result = [Render.Action]

        let rendering: Markdown.Rendering
        let configuration: Markdown.Configuration
        let previewOnly: Bool

        private var currentTimestamp: Timestamp?
        private var currentSection: (title: String, id: String, level: Int)?
        private var existingSlugs: Swift.Set<String> = []
        var tableOfContents: [Markdown.Section] = []

        init(rendering: Markdown.Rendering, configuration: Markdown.Configuration, previewOnly: Bool) {
            self.rendering = rendering
            self.configuration = configuration
            self.previewOnly = previewOnly
        }

        // MARK: - Default Visit

        mutating func defaultVisit(
            _ markup: any SwiftMarkdown.Markup
        ) -> [Render.Action] {
            var actions: [Render.Action] = []
            for child in markup.children {
                if previewOnly && tableOfContents.count > 1 { break }
                actions.append(contentsOf: visit(child))
            }
            return actions
        }

        // MARK: - Text

        mutating func visitText(
            _ text: SwiftMarkdown.Text
        ) -> [Render.Action] {
            rendering.text.render(.init(text: text.string))
        }

        // MARK: - Heading

        mutating func visitHeading(
            _ heading: SwiftMarkdown.Heading
        ) -> [Render.Action] {
            let slug = generateSlug(for: heading.plainText)
            currentSection = (title: heading.plainText, id: slug, level: heading.level)

            var childActions: [Render.Action] = []
            for child in heading.children {
                childActions.append(contentsOf: visit(child))
            }

            return rendering.heading.render(.init(
                level: heading.level,
                slug: slug,
                plainText: heading.plainText,
                children: childActions
            ))
        }

        // MARK: - Paragraph

        mutating func visitParagraph(
            _ paragraph: SwiftMarkdown.Paragraph
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in paragraph.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.paragraph.render(.init(children: childActions))
        }

        // MARK: - Code Block

        mutating func visitCodeBlock(
            _ codeBlock: SwiftMarkdown.CodeBlock
        ) -> [Render.Action] {
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

            return rendering.codeBlock.render(.init(
                language: languageInfo.language,
                code: codeBlock.code,
                highlightLines: languageInfo.highlightLines
            ))
        }

        // MARK: - Block Quote

        mutating func visitBlockQuote(
            _ blockQuote: SwiftMarkdown.BlockQuote
        ) -> [Render.Action] {
            let aside = SwiftMarkdown.Aside(blockQuote)
            let kind = aside.kind.displayName
            let diagnosticLevel = configuration.style.diagnostic.level(aside.kind.rawValue)

            var childActions: [Render.Action] = []
            for child in aside.content {
                childActions.append(contentsOf: visit(child))
            }

            return rendering.blockQuote.render(.init(
                kind: kind,
                children: childActions,
                isDiagnostic: diagnosticLevel != nil,
                diagnosticLevel: diagnosticLevel
            ))
        }

        // MARK: - Emphasis

        mutating func visitEmphasis(
            _ emphasis: SwiftMarkdown.Emphasis
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in emphasis.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.emphasis.render(.init(children: childActions))
        }

        // MARK: - Strong

        mutating func visitStrong(
            _ strong: SwiftMarkdown.Strong
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in strong.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.strong.render(.init(children: childActions))
        }

        // MARK: - Strikethrough

        mutating func visitStrikethrough(
            _ strikethrough: SwiftMarkdown.Strikethrough
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in strikethrough.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.strikethrough.render(.init(children: childActions))
        }

        // MARK: - Inline Code

        mutating func visitInlineCode(
            _ inlineCode: SwiftMarkdown.InlineCode
        ) -> [Render.Action] {
            rendering.inlineCode.render(.init(code: inlineCode.code))
        }

        // MARK: - Link

        mutating func visitLink(
            _ link: SwiftMarkdown.Link
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in link.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.link.render(.init(
                destination: link.destination,
                title: link.title,
                children: childActions
            ))
        }

        // MARK: - Image

        mutating func visitImage(
            _ image: SwiftMarkdown.Image
        ) -> [Render.Action] {
            rendering.image.render(.init(
                source: image.source,
                alt: image.plainText,
                title: image.title
            ))
        }

        // MARK: - Lists

        mutating func visitOrderedList(
            _ orderedList: SwiftMarkdown.OrderedList
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in orderedList.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.orderedList.render(.init(isOrdered: true, children: childActions))
        }

        mutating func visitUnorderedList(
            _ unorderedList: SwiftMarkdown.UnorderedList
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in unorderedList.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.unorderedList.render(.init(isOrdered: false, children: childActions))
        }

        mutating func visitListItem(
            _ listItem: SwiftMarkdown.ListItem
        ) -> [Render.Action] {
            var childActions: [Render.Action] = []
            for child in listItem.children {
                childActions.append(contentsOf: visit(child))
            }
            return rendering.listItem.render(.init(children: childActions))
        }

        // MARK: - Table

        mutating func visitTable(
            _ table: SwiftMarkdown.Table
        ) -> [Render.Action] {
            let headActions = render(
                tagName: "th",
                cells: table.head.cells,
                columnAlignments: table.columnAlignments
            )

            var bodyActions: [Render.Action] = []
            for row in table.body.rows {
                let rowCells = render(
                    tagName: "td",
                    cells: row.cells,
                    columnAlignments: table.columnAlignments
                )
                bodyActions.append(.push(.element(tagName: "tr", isBlock: true, isVoid: false, isPreElement: false)))
                bodyActions.append(contentsOf: rowCells)
                bodyActions.append(.pop(.element(isBlock: true)))
            }

            return rendering.table.render(.init(
                head: headActions,
                body: bodyActions,
                hasHead: !table.head.isEmpty,
                hasBody: !table.body.isEmpty
            ))
        }

        private mutating func render(
            tagName: String,
            cells: some Swift.Sequence<SwiftMarkdown.Table.Cell>,
            columnAlignments: [SwiftMarkdown.Table.ColumnAlignment?]
        ) -> [Render.Action] {
            var actions: [Render.Action] = []
            var column = 0
            for cell in cells {
                if cell.colspan > 0 && cell.rowspan > 0 {
                    actions.append(.push(.element(tagName: tagName, isBlock: false, isVoid: false, isPreElement: false)))
                    if let alignment = columnAlignments[column]?.attributeValue {
                        actions.append(.attribute(set: "align", value: alignment))
                    }
                    if cell.colspan != 1 {
                        actions.append(.attribute(set: "colspan", value: "\(cell.colspan)"))
                    }
                    if cell.rowspan != 1 {
                        actions.append(.attribute(set: "rowspan", value: "\(cell.rowspan)"))
                    }
                    for child in cell.children {
                        actions.append(contentsOf: visit(child))
                    }
                    actions.append(.pop(.element(isBlock: false)))
                    column += Int(cell.colspan)
                }
            }
            return actions
        }

        // MARK: - Breaks

        mutating func visitLineBreak(
            _ lineBreak: SwiftMarkdown.LineBreak
        ) -> [Render.Action] {
            rendering.lineBreak.render()
        }

        mutating func visitSoftBreak(
            _ softBreak: SwiftMarkdown.SoftBreak
        ) -> [Render.Action] {
            rendering.softBreak.render()
        }

        mutating func visitThematicBreak(
            _ thematicBreak: SwiftMarkdown.ThematicBreak
        ) -> [Render.Action] {
            rendering.thematicBreak.render()
        }

        // MARK: - Raw HTML

        mutating func visitHTMLBlock(
            _ html: SwiftMarkdown.HTMLBlock
        ) -> [Render.Action] {
            [.raw(Array(html.rawHTML.utf8))]
        }

        mutating func visitInlineHTML(
            _ inlineHTML: SwiftMarkdown.InlineHTML
        ) -> [Render.Action] {
            [.raw(Array(inlineHTML.rawHTML.utf8))]
        }

        // MARK: - Block Directives

        mutating func visitBlockDirective(
            _ blockDirective: SwiftMarkdown.BlockDirective
        ) -> [Render.Action] {
            // Timestamp directive
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
                            Markdown.Section(
                                title: currentSection.title,
                                id: currentSection.id,
                                level: currentSection.level,
                                timestamp: timestamp
                            )
                        )
                        self.currentSection = nil
                    }
                    return Markdown.Rendering.capture { timestamp }
                }
                return []
            }

            // Build children actions
            var mutableSelf = self
            var childActions: [Render.Action] = []
            for child in blockDirective.children {
                childActions.append(contentsOf: mutableSelf.visit(child))
            }
            self = mutableSelf

            // Build children as AnyView for the directive handler (backward compat)
            let childrenView = HTML.AnyView { Markdown.Rendering.Replay(actions: childActions) }

            let directive = Markdown.Configuration.Directives.Directive(
                name: blockDirective.name,
                rawArguments: blockDirective.argumentText.segments.map(\.trimmedText).joined(separator: " "),
                arguments: parseArguments(from: blockDirective),
                children: childrenView
            )

            let result = configuration.directives.handler(directive)

            switch result {
            case .rendered(let view):
                return Markdown.Rendering.capture { view }
            case .suppress:
                return []
            case .useDefault:
                return childActions
            }
        }

        // MARK: - Helpers

        private mutating func generateSlug(for text: String) -> String {
            let slug = configuration.slugGenerator.generate(
                .init(text: text, existingSlugs: existingSlugs)
            )
            existingSlugs.insert(slug)
            return slug
        }

        private func parseArguments(
            from block: SwiftMarkdown.BlockDirective
        ) -> [String: String] {
            var result: [String: String] = [:]
            let text = block.argumentText.segments.map(\.trimmedText).joined()

            var remaining = text[...]
            while !remaining.isEmpty {
                remaining = remaining.drop { $0.isWhitespace || $0 == "," }
                guard !remaining.isEmpty else { break }

                guard let colonIndex = remaining.firstIndex(of: ":") else { break }
                let key = String(remaining[..<colonIndex]).trimmingCharacters(in: .whitespaces)
                remaining = remaining[remaining.index(after: colonIndex)...]

                remaining = remaining.drop { $0.isWhitespace }
                guard !remaining.isEmpty else { break }

                let firstChar = remaining.first!
                if firstChar == "\"" || firstChar == "'" {
                    let quote = firstChar
                    remaining = remaining.dropFirst()
                    if let endQuote = remaining.firstIndex(of: quote) {
                        result[key] = String(remaining[..<endQuote])
                        remaining = remaining[remaining.index(after: endQuote)...]
                    }
                } else {
                    let endIndex = remaining.firstIndex { $0 == "," || $0.isWhitespace } ?? remaining.endIndex
                    result[key] = String(remaining[..<endIndex])
                    remaining = remaining[endIndex...]
                }
            }

            return result
        }
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
