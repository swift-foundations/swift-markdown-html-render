# ``Markdown_HTML_Rendering``

@Metadata {
    @DisplayName("Markdown HTML Rendering")
    @TitleHeading("Swift Foundations")
}

Renders Apple's `swift-markdown` AST to `swift-html`-rendered HTML: one
renderer per element (blockquote, code block, emphasis, heading, and the
rest), configurable slug generation, link directives, and styling via
`Markdown.Configuration`, plus a flattened `Markdown.Rendering.Converter`
that produces render actions directly instead of nested `HTML.AnyView` trees
(avoiding stack overflow on deeply nested documents).

## When to use this

Reach for this package when Markdown content — authored articles, rendered
documentation, user-submitted text — needs to become HTML output built on
`swift-html-render`, with configurable heading slugs and styling rather than
a fixed conversion. It does not parse Markdown itself (that is Apple's
`swift-markdown`, a direct dependency) and does not define the HTML element
vocabulary it renders into (that is `swift-html-render`).

## Topics

### Related packages

- [swift-markdown](https://github.com/swiftlang/swift-markdown) — the
  Markdown parser producing the AST this package renders.
- [swift-html-render](https://github.com/swift-foundations/swift-html-render) —
  the HTML rendering layer this package's output builds on.
