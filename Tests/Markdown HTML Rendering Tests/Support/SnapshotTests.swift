//
//  SnapshotTests.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering_TestSupport
import InlineSnapshotTesting
import Testing

@MainActor
@Suite(
    .serialized,
    .snapshots(record: .never)
)
struct SnapshotTests {}

extension SnapshotTests {
    @Suite struct MarkdownHTML {}
    @Suite struct Diagnostic {}
    @Suite struct Timestamp {}
}
