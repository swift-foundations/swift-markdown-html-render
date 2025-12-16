//
//  Markdown.HTML.Configuration.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.HTML {
    /// Configuration for customizing markdown rendering behavior.
    ///
    /// Use the default configuration for standard rendering, or customize
    /// individual components using the algebraic struct/closure pattern.
    ///
    /// Example:
    /// ```swift
    /// var config = Markdown.HTML.Configuration.default
    /// config.elements.heading = .init { input in
    ///     tag("h\(input.level)") { input.children }
    ///         .class("custom-heading")
    /// }
    /// Markdown.HTML(configuration: config) { "# Hello" }
    /// ```
    public struct Configuration: Sendable {
        public var elements: Elements
        public var directives: Directives
        public var style: Style
        public var slugGenerator: SlugGenerator

        public init(
            elements: Elements = .default,
            directives: Directives = .default,
            style: Style = .default,
            slugGenerator: SlugGenerator = .default
        ) {
            self.elements = elements
            self.directives = directives
            self.style = style
            self.slugGenerator = slugGenerator
        }
    }
}

extension Markdown.HTML.Configuration {
    public static var `default`: Self {
        .init(
            elements: .default,
            directives: .default,
            style: .default,
            slugGenerator: .default
        )
    }
}
