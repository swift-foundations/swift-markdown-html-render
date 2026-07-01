//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering_Core

extension HTML.Builder {
    @_disfavoredOverload
    static func buildExpression(_ expression: any HTML.View) -> HTML.AnyView {
        HTML.AnyView(expression)
    }

    @_disfavoredOverload
    static func buildFinalResult(_ component: some HTML.View) -> HTML.AnyView {
        let view: any HTML.View = component
        return HTML.AnyView(view)
    }
}
