@_spi(DynamicHTML) import HTML_Rendering_Core
import Render_Primitives

extension Markdown.Rendering {
    /// An HTML leaf view that replays pre-built rendering actions into a context.
    ///
    /// Used inside ``Markdown.Rendering.capture(_:)`` to inject child actions
    /// into HTML view trees rendered through a capturing context.
    struct Replay: HTML.View, Sendable {
        let actions: [Render_Primitives.Render.Action]

        var body: some HTML.View { HTML.Empty() }

        static func _render(
            _ view: borrowing Self, context: inout Render_Primitives.Render.Context
        ) {
            context.splice(view.actions)
        }
    }
}
