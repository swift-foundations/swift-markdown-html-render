//
//  Markdown.Test.Unit.Directive.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown.Test.Unit {
    @Suite
    struct `Directive` {
        @Test
        func `default directives suppress Comment`() {
            let directives = Markdown.Configuration.Directives.default
            let result = directives.handler(.init(
                name: "Comment",
                rawArguments: "",
                arguments: [:],
                children: HTML.AnyView { HTML.Empty() }
            ))
            if case .suppress = result {} else {
                Issue.record("Expected .suppress for Comment directive")
            }
        }

        @Test
        func `default directives use default for unknown`() {
            let directives = Markdown.Configuration.Directives.default
            let result = directives.handler(.init(
                name: "UnknownDirective",
                rawArguments: "",
                arguments: [:],
                children: HTML.AnyView { HTML.Empty() }
            ))
            if case .useDefault = result {} else {
                Issue.record("Expected .useDefault for unknown directive")
            }
        }

        @Test
        func `default directives render Button`() {
            let directives = Markdown.Configuration.Directives.default
            let result = directives.handler(.init(
                name: "Button",
                rawArguments: "https://example.com",
                arguments: [:],
                children: HTML.AnyView { HTML.Text("Click me") }
            ))
            if case .rendered = result {} else {
                Issue.record("Expected .rendered for Button directive")
            }
        }

        @Test
        func `default directives render Video`() {
            let directives = Markdown.Configuration.Directives.default
            let result = directives.handler(.init(
                name: "Video",
                rawArguments: "",
                arguments: ["source": "video.mp4"],
                children: HTML.AnyView { HTML.Empty() }
            ))
            if case .rendered = result {} else {
                Issue.record("Expected .rendered for Video directive")
            }
        }

        @Test
        func `adding combines directive handlers`() {
            let custom = Markdown.Configuration.Directives { directive in
                switch directive.name {
                case "Custom": .suppress
                default: .useDefault
                }
            }
            let combined = Markdown.Configuration.Directives.default.adding(custom)

            let commentResult = combined.handler(.init(
                name: "Comment",
                rawArguments: "",
                arguments: [:],
                children: HTML.AnyView { HTML.Empty() }
            ))
            if case .suppress = commentResult {} else {
                Issue.record("Expected .suppress for Comment in combined")
            }

            let customResult = combined.handler(.init(
                name: "Custom",
                rawArguments: "",
                arguments: [:],
                children: HTML.AnyView { HTML.Empty() }
            ))
            if case .suppress = customResult {} else {
                Issue.record("Expected .suppress for Custom in combined")
            }
        }
    }
}
