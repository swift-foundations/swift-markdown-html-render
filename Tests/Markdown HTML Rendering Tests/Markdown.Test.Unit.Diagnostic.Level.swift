//
//  Markdown.Test.Unit.Diagnostic.Level.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `DiagnosticLevel` {
        @Test
        func `error static constant exists`() {
            let _: Markdown.Diagnostic.Level = .error
        }

        @Test
        func `warning static constant exists`() {
            let _: Markdown.Diagnostic.Level = .warning
        }

        @Test
        func `issue static constant exists`() {
            let _: Markdown.Diagnostic.Level = .issue
        }

        @Test
        func `known issue static constant exists`() {
            let _: Markdown.Diagnostic.Level = .knownIssue
        }

        @Test
        func `runtime warning static constant exists`() {
            let _: Markdown.Diagnostic.Level = .runtimeWarning
        }

        @Test
        func `diagnostic init stores level`() {
            let diagnostic = Markdown.Diagnostic(level: .error)
            _ = diagnostic
        }

        @Test
        func `diagnostic style default resolves error`() {
            let style = Markdown.Configuration.Style.DiagnosticStyle.default
            #expect(style.level("Error") != nil)
        }

        @Test
        func `diagnostic style default resolves warning`() {
            let style = Markdown.Configuration.Style.DiagnosticStyle.default
            #expect(style.level("Warning") != nil)
        }

        @Test
        func `diagnostic style default returns nil for unknown`() {
            let style = Markdown.Configuration.Style.DiagnosticStyle.default
            #expect(style.level("Info") == nil)
        }
    }
}
