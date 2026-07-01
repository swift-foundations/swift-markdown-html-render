import Render_Primitives

extension Render.Context {
    /// Interprets actions with correct CSS class handling.
    ///
    /// The base `interpret` method discards `registerStyle`'s return value,
    /// which means CSS class names are never added. This method handles the
    /// `registerStyle` → `addClass` flow correctly.
    mutating func interpret(markdown actions: [Render.Action]) {
        for action in actions {
            switch action {
            case .style(let declaration, let atRule, let selector, let pseudo):
                if let className = register(style: declaration, atRule: atRule, selector: selector, pseudo: pseudo) {
                    add(class: className)
                }
            default:
                interpret(action)
            }
        }
    }
}
