//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering
import CSS_HTML_Rendering
import CSS_Theming
import Dependencies

extension Diagnostic {
    
    public struct Level: Sendable {
        var icon: Diagnostic.Icon
        var iconColor: DarkModeColor
        var highlightColor: DarkModeColor
        var underlineColor: DarkModeColor?
        var backgroundColor: DarkModeColor
        var detailBackgroundColor: DarkModeColor
        var buttonBackgroundColor: DarkModeColor
    }
}

extension Diagnostic.Level {
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

extension Diagnostic.Level {
    public static let error = Self(
        icon: .error,
        iconColor: .init(light: .hex("CA0900"), dark: .hex("ED2239")),
        highlightColor: .init(light: .hex("EFE9F2"), dark: .hex("3A2C30")),
        underlineColor: .init(light: .hex("E31315"), dark: .hex("E21415")),
        backgroundColor: .init(light: .hex("FFC0C0"), dark: .hex("863432")),
        detailBackgroundColor: .init(light: .hex("EFDCDC"), dark: .hex("402E2B")),
        buttonBackgroundColor: .init(light: .hex("B7AAA9"), dark: .hex("302221"))
    )

    public static let issue = Self(
        icon: .failure,
        iconColor: .init(light: .hex("CA0900"), dark: .hex("ED2239")),
        highlightColor: .init(light: .hex("EFE9F2"), dark: .hex("3A2C30")),
        backgroundColor: .init(light: .hex("FFC0C0"), dark: .hex("863432")),
        detailBackgroundColor: .init(light: .hex("EFDCDC"), dark: .hex("402E2B")),
        buttonBackgroundColor: .init(light: .hex("B7AAA9"), dark: .hex("302221"))
    )

    public static let knownIssue = Self(
        icon: .failure,
        iconColor: .init(light: .hex("8E8E93"), dark: .hex("98989D")),
        highlightColor: .init(light: .hex("F4F4F4"), dark: .hex("333439")),
        backgroundColor: .init(light: .hex("CECED1"), dark: .hex("5F5F61")),
        detailBackgroundColor: .init(light: .hex("E0E0E0"), dark: .hex("373635")),
        buttonBackgroundColor: .init(light: .hex("A8A8A8"), dark: .hex("292828"))
    )

    public static let runtimeWarning = Self(
        icon: .warning,
        iconColor: .init(light: .hex("A156D5"), dark: .hex("A849E8")),
        highlightColor: .init(light: .hex("E9EAFD"), dark: .hex("3A3447")),
        backgroundColor: .init(light: .hex("D9B8F3"), dark: .hex("714088")),
        detailBackgroundColor: .init(light: .hex("EBE1F2"), dark: .hex("3A303C")),
        buttonBackgroundColor: .init(light: .hex("ACA3AF"), dark: .hex("2B252E"))
    )

    public static let warning = Self(
        icon: .warning,
        iconColor: .init(light: .hex("FFBA00"), dark: .hex("FFC502")),
        highlightColor: .init(light: .hex("FFFAEA"), dark: .hex("3F3A30")),
        underlineColor: .init(light: .hex("FEC300")),
        backgroundColor: .init(light: .hex("FFEAAD"), dark: .hex("8F7723")),
        detailBackgroundColor: .init(light: .hex("EFE9D6"), dark: .hex("413B29")),
        buttonBackgroundColor: .init(light: .hex("B4AEA0"), dark: .hex("312C1E"))
    )
}
