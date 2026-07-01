import CSS_HTML_Rendering
@_spi(DynamicHTML) import HTML_Rendering_Core
import HTML_Rendering
import Render_Primitives
import Ownership_Mutable_Primitives

extension Markdown.Rendering {
    /// A cached action sequence with a splice point for children.
    ///
    /// Compile once from an HTML view tree, then reuse on every call.
    /// The view tree is rendered through a capturing context exactly once
    /// (at `static let` initialization); subsequent calls splice children
    /// into the cached prefix/suffix — no view construction, no `_render` recursion.
    ///
    /// ```swift
    /// private static let frame = Markdown.Rendering.Frame {
    ///     HTML_Rendering.Paragraph {
    ///         Markdown.Rendering.Frame.Placeholder()
    ///     }
    ///     .css.lineHeight(1.5).padding(.zero).margin(.zero)
    /// }
    ///
    /// // Each call: O(1) structure + O(children) splice
    /// frame.applying(children: input.children)
    /// ```
    public struct Frame: Sendable {
        /// Actions before the children splice point.
        public let prefix: [Action]
        /// Actions after the children splice point.
        public let suffix: [Action]

        /// Captures an HTML view tree, splitting at the ``Placeholder``.
        ///
        /// The view tree is rendered once through a capturing context.
        /// The ``Placeholder`` marks where children will be spliced.
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

        /// Splices children into the cached frame.
        ///
        /// Returns: prefix + children + suffix.
        public func applying(children: [Action]) -> [Action] {
            var result: [Action] = []
            result.reserveCapacity(prefix.count + children.count + suffix.count)
            result.append(contentsOf: prefix)
            result.append(contentsOf: children)
            result.append(contentsOf: suffix)
            return result
        }

        /// Splices children and attributes into the cached frame.
        ///
        /// Attributes are injected before the innermost element push,
        /// matching the position that view modifiers (`.id()`, `.attribute()`)
        /// produce in a normal capture.
        ///
        /// Returns: prefix (with attributes before last element push) + children + suffix.
        public func applying(
            children: [Action],
            attributes: [Action]
        ) -> [Action] {
            if attributes.isEmpty { return applying(children: children) }

            // Find the last pushElement in prefix — attributes go before it
            var insertIndex = prefix.count
            for i in stride(from: prefix.count - 1, through: 0, by: -1) {
                if case .push(.element) = prefix[i] {
                    insertIndex = i
                    break
                }
            }

            var result: [Action] = []
            result.reserveCapacity(prefix.count + attributes.count + children.count + suffix.count)
            result.append(contentsOf: prefix[..<insertIndex])
            result.append(contentsOf: attributes)
            result.append(contentsOf: prefix[insertIndex...])
            result.append(contentsOf: children)
            result.append(contentsOf: suffix)
            return result
        }
    }
}

// MARK: - Placeholder

extension Markdown.Rendering.Frame {
    /// Marks the children splice point inside a ``Frame`` capture.
    ///
    /// Place exactly one `Placeholder()` in the view tree passed to `Frame.init`.
    /// The frame captures everything before it as `prefix` and everything after as `suffix`.
    public struct Placeholder: HTML.View, Sendable {
        public init() {}

        public var body: some HTML.View { HTML.Empty() }

        public static func _render(
            _ view: borrowing Self,
            context: inout Render_Primitives.Render.Context
        ) {
            // Signal the frame capturer to record the split point.
            // For non-frame contexts this is a no-op (empty splice).
            context.splice([])
        }
    }
}

// MARK: - Frame Capture State

extension Markdown.Rendering.Frame {
    struct CaptureState {
        var actions: [Render_Primitives.Render.Action] = []
        var childrenIndex: Int? = nil
    }
}

// MARK: - Frame-Capturing Context Factory

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
                element: { state.value.actions.append(.push(.element(tagName: $0, isBlock: $1, isVoid: $2, isPreElement: $3))) },
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
                state.value.actions.append(.style(register: decl, atRule: atRule, selector: sel, pseudo: pseudo))
                return nil
            },
            spliceActions: { actions in
                if actions.isEmpty {
                    // Empty splice from Placeholder — record the split point
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
