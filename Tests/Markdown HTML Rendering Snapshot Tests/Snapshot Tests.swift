//
//  Snapshot Tests.swift
//  swift-markdown-html-rendering
//

import HTML_Rendering_Core_Test_Support
import Markdown_HTML_Rendering
import Testing

@MainActor
@Suite(
    .serialized,
    .snapshots(configuration: .init(recording: .missing))
)
struct `Snapshot Tests` {}

extension `Snapshot Tests` {
    @Suite struct `Markdown HTML` {}
    @Suite struct `Diagnostic` {}
    @Suite struct `Timestamp` {}
}
