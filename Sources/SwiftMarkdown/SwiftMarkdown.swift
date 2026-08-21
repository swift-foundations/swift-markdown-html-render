@_exported import Markdown

public enum SwiftMarkdown {}

extension SwiftMarkdown {

    public typealias Document = Markdown.Document
    public typealias BlockDirective = Markdown.BlockDirective

    public typealias BlockQuote = Markdown.BlockQuote
    public typealias CodeBlock = Markdown.CodeBlock
    public typealias Heading = Markdown.Heading
    public typealias HTMLBlock = Markdown.HTMLBlock
    public typealias OrderedList = Markdown.OrderedList
    public typealias UnorderedList = Markdown.UnorderedList
    public typealias ListItem = Markdown.ListItem
    public typealias Paragraph = Markdown.Paragraph
    public typealias ThematicBreak = Markdown.ThematicBreak
    public typealias Table = Markdown.Table

    public typealias Emphasis = Markdown.Emphasis
    public typealias Strong = Markdown.Strong
    public typealias Strikethrough = Markdown.Strikethrough
    public typealias InlineCode = Markdown.InlineCode
    public typealias InlineHTML = Markdown.InlineHTML
    public typealias Image = Markdown.Image
    public typealias Link = Markdown.Link
    public typealias Text = Markdown.Text
    public typealias SoftBreak = Markdown.SoftBreak
    public typealias LineBreak = Markdown.LineBreak

    public typealias Markup = Markdown.Markup
    public typealias MarkupVisitor = Markdown.MarkupVisitor
    public typealias MarkupWalker = Markdown.MarkupWalker

    public typealias Aside = Markdown.Aside
}
