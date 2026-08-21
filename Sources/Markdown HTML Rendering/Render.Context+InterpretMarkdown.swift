import Render_Primitives

extension Render.Context {

    mutating func interpret(markdown actions: [Render.Action]) {
        for action in actions {
            switch action {
            case .style(let declaration, let atRule, let selector, let pseudo):
                if let className = register(
                    style: declaration,
                    atRule: atRule,
                    selector: selector,
                    pseudo: pseudo
                ) {
                    add(class: className)
                }

            default:
                interpret(action)
            }
        }
    }
}
