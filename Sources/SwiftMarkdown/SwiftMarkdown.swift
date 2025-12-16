//
//  SwiftMarkdown.swift
//  swift-markdown-html-rendering
//
//  Re-exports swift-markdown types under the SwiftMarkdown namespace.
//  This separate module allows us to use `enum Markdown` in the main module
//  without shadowing the swift-markdown module.
//
//  TODO: Remove once SE-0491 (Module Selectors) lands and use proper disambiguation.
//  https://forums.swift.org/t/se-0491-module-selectors-for-name-disambiguation/82124
//

@_exported import Markdown

// MARK: - SwiftMarkdown Namespace

/// Namespace for swift-markdown types, avoiding collision with our `Markdown` enum.
public enum SwiftMarkdown {

    // MARK: - Document Types

    public typealias Document = Markdown.Document
    public typealias BlockDirective = Markdown.BlockDirective

    // MARK: - Block Types

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

    // MARK: - Inline Types

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

    // MARK: - Protocols & Visitors

    public typealias Markup = Markdown.Markup
    public typealias MarkupVisitor = Markdown.MarkupVisitor
    public typealias MarkupWalker = Markdown.MarkupWalker

    // MARK: - Aside

    public typealias Aside = Markdown.Aside
}
