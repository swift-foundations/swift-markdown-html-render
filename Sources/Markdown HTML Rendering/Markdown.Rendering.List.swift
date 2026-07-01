import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Rendering {
    public struct List: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.List {
    public struct Input: Sendable {
        public let isOrdered: Bool
        public let children: [Markdown.Rendering.Action]

        public init(isOrdered: Bool, children: [Markdown.Rendering.Action]) {
            self.isOrdered = isOrdered
            self.children = children
        }
    }
}

extension Markdown.Rendering.List {
    private static let orderedFrame = Markdown.Rendering.Frame {
        OrderedList {
            Markdown.Rendering.Frame.Placeholder()
        }
        .css
        .display(Display.flex)
        .flexDirection(FlexDirection.column)
        .rowGap(RowGap.length(.rem(0.5)))
    }

    private static let unorderedFrame = Markdown.Rendering.Frame {
        UnorderedList {
            Markdown.Rendering.Frame.Placeholder()
        }
        .css
        .display(Display.flex)
        .flexDirection(FlexDirection.column)
        .rowGap(RowGap.length(.rem(0.5)))
        .marginTop(MarginTop.zero)
        .marginBottom(MarginBottom.zero)
    }

    public static var defaultOrdered: Self {
        .init { input in orderedFrame.applying(children: input.children) }
    }

    public static var defaultUnordered: Self {
        .init { input in unorderedFrame.applying(children: input.children) }
    }
}
