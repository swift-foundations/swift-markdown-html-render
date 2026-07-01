import Render_Primitives
public import Ownership_Mutable_Primitives

extension Render.Context {
    /// Creates a rendering context that captures all operations as ``Render.Action`` values.
    ///
    /// Used to convert HTML view trees into flat action arrays for the
    /// ``Markdown.Rendering.Converter`` pipeline.
    static func capturing(into buffer: Ownership.Mutable<[Render.Action]>) -> Self {
        .init(
            text: { buffer.value.append(.text($0)) },
            break: Render.Break(
                line: { buffer.value.append(.break(.line)) },
                thematic: { buffer.value.append(.break(.thematic)) },
                page: { buffer.value.append(.break(.page)) }
            ),
            image: { buffer.value.append(.image(source: $0, alt: $1)) },
            push: Render.Push(
                block: { buffer.value.append(.push(.block(role: $0, style: $1))) },
                inline: { buffer.value.append(.push(.inline(role: $0, style: $1))) },
                list: { buffer.value.append(.push(.list(kind: $0, start: $1))) },
                item: { buffer.value.append(.push(.item)) },
                link: { buffer.value.append(.push(.link(destination: $0))) },
                attributes: { buffer.value.append(.push(.attributes)) },
                element: { buffer.value.append(.push(.element(tagName: $0, isBlock: $1, isVoid: $2, isPreElement: $3))) },
                style: { buffer.value.append(.push(.style)) }
            ),
            pop: Render.Pop(
                block: { buffer.value.append(.pop(.block)) },
                inline: { buffer.value.append(.pop(.inline)) },
                list: { buffer.value.append(.pop(.list)) },
                item: { buffer.value.append(.pop(.item)) },
                link: { buffer.value.append(.pop(.link)) },
                attributes: { buffer.value.append(.pop(.attributes)) },
                element: { buffer.value.append(.pop(.element(isBlock: $0))) },
                style: { buffer.value.append(.pop(.style)) }
            ),
            setAttribute: { buffer.value.append(.attribute(set: $0, value: $1)) },
            addClass: { buffer.value.append(.class(add: $0)) },
            writeRaw: { buffer.value.append(.raw($0)) },
            registerStyle: { decl, atRule, sel, pseudo in
                buffer.value.append(.style(register: decl, atRule: atRule, selector: sel, pseudo: pseudo))
                return nil
            },
            spliceActions: { buffer.value.append(contentsOf: $0) }
        )
    }
}
