//
//  Markdown.Configuration.Style.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Configuration {
    /// Configuration for styling various markdown components.
    public struct Style: Sendable {
        public var diagnostic: DiagnosticStyle
        public var blockQuote: BlockQuoteStyle
        public var icons: Icons

        public init(
            diagnostic: DiagnosticStyle = .default,
            blockQuote: BlockQuoteStyle = .default,
            icons: Icons = .default
        ) {
            self.diagnostic = diagnostic
            self.blockQuote = blockQuote
            self.icons = icons
        }

        public static var `default`: Self { .init() }
    }
}

// MARK: - DiagnosticStyle

extension Markdown.Configuration.Style {
    /// Configuration for diagnostic rendering (errors, warnings, etc.)
    public struct DiagnosticStyle: Sendable {
        public var level: @Sendable (_ name: String) -> Markdown.Diagnostic.Level?

        public init(_ level: @escaping @Sendable (_ name: String) -> Markdown.Diagnostic.Level?) {
            self.level = level
        }

        public static var `default`: Self {
            .init { name in
                switch name {
                case "Error": return .error
                case "Expected Failure": return .knownIssue
                case "Failed": return .issue
                case "Runtime Warning": return .runtimeWarning
                case "Warning": return .warning
                default: return nil
                }
            }
        }

        /// Add a custom diagnostic level for a specific name.
        public func adding(_ name: String, _ diagnosticLevel: Markdown.Diagnostic.Level) -> Self {
            DiagnosticStyle { n in
                if n == name { return diagnosticLevel }
                return self.level(n)
            }
        }
    }
}

// MARK: - BlockQuoteStyle

extension Markdown.Configuration.Style {
    /// Configuration for block quote styling.
    public struct BlockQuoteStyle: Sendable {
        public var style:
            @Sendable (_ name: String) -> (
                backgroundColor: DarkModeColor, borderColor: DarkModeColor
            )

        public init(
            _ style:
                @escaping @Sendable (_ name: String) -> (
                    backgroundColor: DarkModeColor, borderColor: DarkModeColor
                )
        ) {
            self.style = style
        }

        public static var `default`: Self {
            .init { name in
                switch name {
                case "Warning", "Correction":
                    return (backgroundColor: .background.warning, borderColor: .border.warning)
                case "Important":
                    return (
                        backgroundColor: .background.highlighted, borderColor: .border.highlighted
                    )
                case "Announcement", "Tip":
                    return (backgroundColor: .background.info, borderColor: .border.info)
                default:
                    return (backgroundColor: .background.neutral, borderColor: .border.neutral)
                }
            }
        }

        /// Add a custom style for a specific block quote type.
        public func adding(
            _ name: String,
            backgroundColor: DarkModeColor,
            borderColor: DarkModeColor
        ) -> Self {
            BlockQuoteStyle { n in
                if n == name { return (backgroundColor: backgroundColor, borderColor: borderColor) }
                return self.style(n)
            }
        }
    }
}

// MARK: - Icons

extension Markdown.Configuration.Style {
    /// Configuration for icon rendering.
    public struct Icons: Sendable {
        public var link: @Sendable () -> HTML.AnyView
        public var diagnostic: @Sendable (DiagnosticIconKind) -> HTML.AnyView

        public enum DiagnosticIconKind: Sendable {
            case error
            case failure
            case warning
        }

        public init(
            link: @escaping @Sendable () -> HTML.AnyView,
            diagnostic: @escaping @Sendable (DiagnosticIconKind) -> HTML.AnyView
        ) {
            self.link = link
            self.diagnostic = diagnostic
        }

        public static var `default`: Self {
            .init(
                link: {
                    HTML.AnyView {
                        LinkIcon()
                    }
                },
                diagnostic: { kind in
                    HTML.AnyView {
                        switch kind {
                        case .error:
                            Markdown.Diagnostic.Icon.error
                        case .failure:
                            Markdown.Diagnostic.Icon.failure
                        case .warning:
                            Markdown.Diagnostic.Icon.warning
                        }
                    }
                }
            )
        }
    }
}
