//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import CSS_HTML_Rendering
import CSS_Theming

import HTML_Rendering

extension Markdown.Diagnostic {

    public struct Level: Sendable {
        var icon: Markdown.Diagnostic.Icon
        var iconColor: DarkModeColor
        var highlightColor: DarkModeColor
        var underlineColor: DarkModeColor?
        var backgroundColor: DarkModeColor
        var detailBackgroundColor: DarkModeColor
        var buttonBackgroundColor: DarkModeColor
    }
}

extension Markdown.Diagnostic.Level {
    init?(aside: SwiftMarkdown.Aside) {
        switch aside.kind.rawValue {
        case "Error": self = .error
        case "Expected Failure": self = .knownIssue
        case "Failed": self = .issue
        case "Runtime Warning": self = .runtimeWarning
        case "Warning": self = .warning
        default: return nil
        }
    }
}

extension Markdown.Diagnostic.Level {
    public static let error = Self(
        icon: .error,
        iconColor: .text.error,
        highlightColor: .background.errorMuted,
        underlineColor: .border.error,
        backgroundColor: .background.error,
        detailBackgroundColor: .background.errorMuted,
        buttonBackgroundColor: .background.tertiary
    )

    public static let issue = Self(
        icon: .failure,
        iconColor: .text.error,
        highlightColor: .background.errorMuted,
        backgroundColor: .background.error,
        detailBackgroundColor: .background.errorMuted,
        buttonBackgroundColor: .background.tertiary
    )

    public static let knownIssue = Self(
        icon: .failure,
        iconColor: .gray,
        highlightColor: .background.tertiary,
        backgroundColor: .background.neutral,
        detailBackgroundColor: .background.tertiary,
        buttonBackgroundColor: .background.secondary
    )

    public static let runtimeWarning = Self(
        icon: .warning,
        iconColor: .purple,
        highlightColor: .background.infoMuted,
        backgroundColor: .background.info,
        detailBackgroundColor: .background.infoMuted,
        buttonBackgroundColor: .background.tertiary
    )

    public static let warning = Self(
        icon: .warning,
        iconColor: .yellow,
        highlightColor: .background.warningMuted,
        underlineColor: .border.warning,
        backgroundColor: .background.warning,
        detailBackgroundColor: .background.warningMuted,
        buttonBackgroundColor: .background.tertiary
    )
}
