//
//  Markdown.Configuration.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown {
    /// Configuration for customizing markdown rendering behavior.
    ///
    /// Use the default configuration for standard rendering, or customize
    /// individual components.
    ///
    /// Example:
    /// ```swift
    /// var config = Markdown.Configuration.default
    /// config.slugGenerator = .init { input in input.plainText.lowercased() }
    /// Markdown(configuration: config) { "# Hello" }
    /// ```
    public struct Configuration: Sendable {
        public var directives: Directives
        public var style: Style
        public var slugGenerator: SlugGenerator

        public init(
            directives: Directives = .default,
            style: Style = .default,
            slugGenerator: SlugGenerator = .default
        ) {
            self.directives = directives
            self.style = style
            self.slugGenerator = slugGenerator
        }
    }
}

extension Markdown.Configuration {
    public static var `default`: Self {
        .init(
            directives: .default,
            style: .default,
            slugGenerator: .default
        )
    }
}
