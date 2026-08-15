extension String {
    // reason: `SwiftMarkdown.Markup` is a protocol from the upstream swift-markdown
    // package; its own API surface (e.g. `MarkupWalker.visit`) is fixed to `any Markup`,
    // so a generic constraint here cannot be threaded through without forking the walker.
    // swiftlint:disable:next no_any_protocol_existential
    public init(stripping markup: any SwiftMarkdown.Markup) {
        var walker = PlainTextWalker()
        walker.visit(markup)
        self = walker.text
    }

    public init(stripping markdown: String) {
        self.init(stripping: SwiftMarkdown.Document(parsing: markdown))
    }
}

private struct PlainTextWalker: SwiftMarkdown.MarkupWalker {
    var text = ""
}

extension PlainTextWalker {
    mutating func visitEmphasis(_ emphasis: SwiftMarkdown.Emphasis) {
        text.append(emphasis.plainText)
    }
    mutating func visitHeading(_ heading: SwiftMarkdown.Heading) {
        text.append(heading.plainText)
    }
    mutating func visitInlineCode(_ inlineCode: SwiftMarkdown.InlineCode) {
        text.append(inlineCode.code)
    }
    mutating func visitLineBreak(_ lineBreak: SwiftMarkdown.LineBreak) {
        text.append(" ")
    }
    mutating func visitLink(_ link: SwiftMarkdown.Link) {
        text.append(link.plainText)
    }
    mutating func visitListItem(_ listItem: SwiftMarkdown.ListItem) {
        for child in listItem.children { visit(child) }
    }
    mutating func visitSoftBreak(_ softBreak: SwiftMarkdown.SoftBreak) {
        text.append(" ")
    }
    mutating func visitStrong(_ strong: SwiftMarkdown.Strong) {
        text.append(strong.plainText)
    }
    mutating func visitText(_ text: SwiftMarkdown.Text) {
        self.text.append(text.plainText)
    }
    mutating func visitUnorderedList(_ unorderedList: SwiftMarkdown.UnorderedList) {
        for child in unorderedList.children { visit(child) }
    }
}
