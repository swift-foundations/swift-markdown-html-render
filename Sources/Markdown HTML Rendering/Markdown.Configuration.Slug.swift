import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Configuration {

    public struct SlugGenerator: Sendable {
        public var generate: @Sendable (Input) -> String

        public init(_ generate: @escaping @Sendable (Input) -> String) {
            self.generate = generate
        }
    }
}

extension Markdown.Configuration.SlugGenerator {
    public struct Input: Sendable {
        public let text: String
        public let existingSlugs: Swift.Set<String>

        public init(text: String, existingSlugs: Swift.Set<String>) {
            self.text = text
            self.existingSlugs = existingSlugs
        }
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
