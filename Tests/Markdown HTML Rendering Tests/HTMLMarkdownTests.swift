//
//  HTMLMarkdownTests.swift
//  swift-html-markdown
//
//  Created by Coen ten Thije Boonkkamp on 12/09/2025.
//

import Foundation
import Testing
@testable import Markdown_HTML_Rendering

@Suite("HTMLMarkdown Tests")
struct HTMLMarkdownTests {
    @Test("Basic markdown rendering")
    func basicMarkdownRendering() {
        let markdown = HTMLMarkdown("# Hello World")
        #expect(markdown.tableOfContents.count >= 0)
    }
}
