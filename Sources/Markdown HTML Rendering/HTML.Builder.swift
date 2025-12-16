//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Renderable

extension HTML.Builder {
    @_disfavoredOverload
    static func buildExpression(_ expression: any HTML.View) -> HTML.AnyView {
        AnyHTML(expression)
    }

    @_disfavoredOverload
    static func buildFinalResult(_ component: some HTML.View) -> HTML.AnyView {
        AnyHTML { component }
    }
}
