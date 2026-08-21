import CSS_HTML_Rendering
import HTML_Rendering
@_spi(DynamicHTML) import HTML_Rendering_Core
import Ownership_Mutable_Primitives
import Render_Primitives

extension Markdown.Rendering {

    public struct Frame: Sendable {

        public let prefix: [Action]

        public let suffix: [Action]

        public init<V: HTML.View>(@HTML.Builder _ content: () -> V) {
            let state = Ownership.Mutable(CaptureState())
            var context = Render_Primitives.Render.Context.frameCapturer(into: state)
            context.render(content())

            guard let splitIndex = state.value.childrenIndex else {
                preconditionFailure("Frame requires exactly one Placeholder()")
            }

            self.prefix = Array(state.value.actions[..<splitIndex])
            self.suffix = Array(state.value.actions[splitIndex...])
        }
    }
}

extension Markdown.Rendering.Frame {

    public func applying(children: [Markdown.Rendering.Action]) -> [Markdown.Rendering.Action] {
        var result: [Markdown.Rendering.Action] = []
        result.reserveCapacity(prefix.count + children.count + suffix.count)
        result.append(contentsOf: prefix)
        result.append(contentsOf: children)
        result.append(contentsOf: suffix)
        return result
    }

    public func applying(
        children: [Markdown.Rendering.Action],
        attributes: [Markdown.Rendering.Action]
    ) -> [Markdown.Rendering.Action] {
        if attributes.isEmpty { return applying(children: children) }

        var insertIndex = prefix.count
        for i in stride(from: prefix.count - 1, through: 0, by: -1) {
            if case .push(.element) = prefix[i] {
                insertIndex = i
                break
            }
        }

        var result: [Markdown.Rendering.Action] = []
        result.reserveCapacity(prefix.count + attributes.count + children.count + suffix.count)
        result.append(contentsOf: prefix[..<insertIndex])
        result.append(contentsOf: attributes)
        result.append(contentsOf: prefix[insertIndex...])
        result.append(contentsOf: children)
        result.append(contentsOf: suffix)
        return result
    }
}

extension Markdown.Rendering.Frame {

    public struct Placeholder: HTML.View, Sendable {
        public init() {}
    }
}

extension Markdown.Rendering.Frame.Placeholder {
    public var body: some HTML.View { HTML.Empty() }

    public static func _render(
        _ view: borrowing Self,
        context: inout Render_Primitives.Render.Context
    ) {

        context.splice([])
    }
}

extension Markdown.Rendering.Frame {
    struct CaptureState {
        var actions: [Render_Primitives.Render.Action] = []
        var childrenIndex: Int? = nil
    }
}

extension Render_Primitives.Render.Context {
    static func frameCapturer(
        into state: Ownership.Mutable<Markdown.Rendering.Frame.CaptureState>
    ) -> Self {
        .init(
            text: { state.value.actions.append(.text($0)) },
            break: Render.Break(
                line: { state.value.actions.append(.break(.line)) },
                thematic: { state.value.actions.append(.break(.thematic)) },
                page: { state.value.actions.append(.break(.page)) }
            ),
            image: { state.value.actions.append(.image(source: $0, alt: $1)) },
            push: Render.Push(
                block: { state.value.actions.append(.push(.block(role: $0, style: $1))) },
                inline: { state.value.actions.append(.push(.inline(role: $0, style: $1))) },
                list: { state.value.actions.append(.push(.list(kind: $0, start: $1))) },
                item: { state.value.actions.append(.push(.item)) },
                link: { state.value.actions.append(.push(.link(destination: $0))) },
                attributes: { state.value.actions.append(.push(.attributes)) },
                element: {
                    state.value.actions.append(
                        .push(.element(tagName: $0, isBlock: $1, isVoid: $2, isPreElement: $3))
                    )
                },
                style: { state.value.actions.append(.push(.style)) }
            ),
            pop: Render.Pop(
                block: { state.value.actions.append(.pop(.block)) },
                inline: { state.value.actions.append(.pop(.inline)) },
                list: { state.value.actions.append(.pop(.list)) },
                item: { state.value.actions.append(.pop(.item)) },
                link: { state.value.actions.append(.pop(.link)) },
                attributes: { state.value.actions.append(.pop(.attributes)) },
                element: { state.value.actions.append(.pop(.element(isBlock: $0))) },
                style: { state.value.actions.append(.pop(.style)) }
            ),
            setAttribute: { state.value.actions.append(.attribute(set: $0, value: $1)) },
            addClass: { state.value.actions.append(.class(add: $0)) },
            writeRaw: { state.value.actions.append(.raw($0)) },
            registerStyle: { decl, atRule, sel, pseudo in
                state.value.actions.append(
                    .style(register: decl, atRule: atRule, selector: sel, pseudo: pseudo)
                )
                return nil
            },
            spliceActions: { actions in
                if actions.isEmpty {

                    precondition(
                        state.value.childrenIndex == nil,
                        "Frame supports exactly one Placeholder()"
                    )
                    state.value.childrenIndex = state.value.actions.count
                } else {
                    state.value.actions.append(contentsOf: actions)
                }
            }
        )
    }
}
