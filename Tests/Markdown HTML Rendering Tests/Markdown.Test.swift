//
//  Markdown.Test.swift
//  swift-markdown-html-rendering
//

import Markdown_HTML_Rendering
import Testing

extension Markdown {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}
