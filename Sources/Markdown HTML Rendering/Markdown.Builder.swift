import HTML_Rendering

extension Markdown {
    @resultBuilder
    public struct Builder {
        public static func buildArray(_ components: [[String]]) -> [String] {
            return components.flatMap { $0 }
        }

        public static func buildBlock() -> [String] {
            return []
        }

        public static func buildBlock(_ components: String...) -> [String] {
            return components
        }

        public static func buildBlock(_ components: [String]...) -> [String] {
            return components.flatMap { $0 }
        }

        public static func buildEither(first component: [String]) -> [String] {
            return component
        }

        public static func buildEither(second component: [String]) -> [String] {
            return component
        }

        public static func buildExpression(_ expression: String) -> [String] {
            return [expression]
        }

        public static func buildExpression(_ expression: [String]) -> [String] {
            return expression
        }

        public static func buildExpression(_ expression: [[String]]) -> [String] {
            return expression.flatMap { $0 }
        }

        public static func buildOptional(_ component: [String]?) -> [String] {
            return component ?? []
        }

        public static func buildExpression(_ expression: String?) -> [String] {
            return expression.map { [$0] } ?? []
        }

        public static func buildLimitedAvailability(_ component: [String]) -> [String] {
            return component
        }

        public static func buildFinalResult(_ component: [String]) -> String {
            return component.joined(separator: "\n")
        }
    }
}

extension Markdown.Builder {

    public static func buildFinalResultWithParagraphs(_ component: [String]) -> String {
        return component.filter { !$0.isEmpty }.joined(separator: "\n\n")
    }

    public static func processMarkdownSections(_ lines: [String]) -> String {
        var result: [String] = []
        var currentSection: [String] = []

        for line in lines {
            if line.isEmpty {
                if !currentSection.isEmpty {
                    result.append(currentSection.joined(separator: "\n"))
                    currentSection.removeAll()
                }
            } else {
                currentSection.append(line)
            }
        }

        if !currentSection.isEmpty {
            result.append(currentSection.joined(separator: "\n"))
        }

        return result.joined(separator: "\n\n")
    }
}

extension String {
    @_disfavoredOverload
    public init(@Markdown.Builder markdown builder: () -> String) {
        self = builder()
    }
    @_disfavoredOverload

    public init(@Markdown.Builder markdownWithParagraphs builder: () -> [String]) {
        self = Markdown.Builder.buildFinalResultWithParagraphs(builder())
    }
    @_disfavoredOverload

    public init(@Markdown.Builder markdownSections builder: () -> [String]) {
        self = Markdown.Builder.processMarkdownSections(builder())
    }
}
