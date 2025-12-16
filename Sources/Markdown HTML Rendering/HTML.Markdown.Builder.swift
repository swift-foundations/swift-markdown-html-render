//
//  HTML.Markdown.Builder.swift
//  swift-html-markdown
//
//  Created by Coen ten Thije Boonkkamp on 08/08/2024.
//

import HTML_Rendering

extension HTML.Markdown {
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
        
        // Add missing methods for completeness
        public static func buildLimitedAvailability(_ component: [String]) -> [String] {
            return component
        }

        public static func buildFinalResult(_ component: [String]) -> String {
            return component.joined(separator: "\n")
        }
    }
}


// Enhanced extension with Markdown-specific formatting options
extension HTML.Markdown.Builder {
    /// Joins components with double newlines for paragraph separation
    public static func buildFinalResultWithParagraphs(_ component: [String]) -> String {
        return component.filter { !$0.isEmpty }.joined(separator: "\n\n")
    }
    
    /// Processes markdown content with proper spacing for sections
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
    public init(@HTML.Markdown.Builder markdown builder: () -> String) {
        self = builder()
    }
    @_disfavoredOverload
    /// Creates a markdown string with proper paragraph spacing (double newlines between sections)
    public init(@HTML.Markdown.Builder markdownWithParagraphs builder: () -> [String]) {
        self = HTML.Markdown.Builder.buildFinalResultWithParagraphs(builder())
    }
    @_disfavoredOverload
    /// Creates a markdown string with intelligent section processing
    public init(@HTML.Markdown.Builder markdownSections builder: () -> [String]) {
        self = HTML.Markdown.Builder.processMarkdownSections(builder())
    }
}

extension HTML.Markdown {
    public init(
        @HTML.Markdown.Builder _ markdown: () -> String,
        previewOnly: Bool = false
    ) {
        self = .init(markdown(), previewOnly: previewOnly)
    }
}
