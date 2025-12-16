//
//  Markdown.HTML.Configuration.SlugGenerator.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering
import CSS_HTML_Rendering
import CSS_Theming

extension Markdown.HTML.Configuration {
    /// Configuration for generating URL-friendly slugs from heading text.
    ///
    /// Example:
    /// ```swift
    /// // Custom slug generator with prefix
    /// config.slugGenerator = .prefixed("doc")
    /// // "Hello World" -> "doc-hello-world"
    /// ```
    public struct SlugGenerator: Sendable {
        public var generate: @Sendable (Input) -> String

        public struct Input: Sendable {
            public let text: String
            public let existingSlugs: Set<String>

            public init(text: String, existingSlugs: Set<String>) {
                self.text = text
                self.existingSlugs = existingSlugs
            }
        }

        public init(_ generate: @escaping @Sendable (Input) -> String) {
            self.generate = generate
        }

        public static var `default`: Self {
            .init { input in
                let baseSlug = input.text
                    .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
                    .joined(separator: "-")
                    .lowercased()

                var slug = baseSlug
                var generation = 0

                while input.existingSlugs.contains(slug) {
                    generation += 1
                    slug = "\(baseSlug)-\(generation)"
                }

                return slug
            }
        }

        /// Create a slug generator that prefixes all slugs.
        public static func prefixed(_ prefix: String) -> Self {
            .init { input in
                let baseSlug = Self.default.generate(.init(text: input.text, existingSlugs: []))
                let prefixedBase = "\(prefix)-\(baseSlug)"

                var slug = prefixedBase
                var generation = 0

                while input.existingSlugs.contains(slug) {
                    generation += 1
                    slug = "\(prefixedBase)-\(generation)"
                }

                return slug
            }
        }

        /// Create a slug generator with a custom transform.
        public static func custom(_ transform: @escaping @Sendable (String) -> String) -> Self {
            .init { input in
                let baseSlug = transform(input.text)

                var slug = baseSlug
                var generation = 0

                while input.existingSlugs.contains(slug) {
                    generation += 1
                    slug = "\(baseSlug)-\(generation)"
                }

                return slug
            }
        }
    }
}
