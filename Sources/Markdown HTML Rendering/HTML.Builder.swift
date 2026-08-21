import HTML_Rendering_Core

extension HTML.Builder {
    @_disfavoredOverload
    static func buildExpression(_ expression: some HTML.View) -> HTML.AnyView {
        HTML.AnyView(expression)
    }

    @_disfavoredOverload
    static func buildFinalResult(_ component: some HTML.View) -> HTML.AnyView {
        HTML.AnyView(component)
    }
}
