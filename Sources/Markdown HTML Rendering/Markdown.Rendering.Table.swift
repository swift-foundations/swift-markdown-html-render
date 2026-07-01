import HTML_Rendering

extension Markdown.Rendering {
    public struct Table: Sendable {
        public var render: @Sendable (Input) -> [Render.Action]

        public init(render: @escaping @Sendable (Input) -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.Table {
    public struct Input: Sendable {
        public let head: [Markdown.Rendering.Action]
        public let body: [Markdown.Rendering.Action]
        public let hasHead: Bool
        public let hasBody: Bool

        public init(
            head: [Markdown.Rendering.Action],
            body: [Markdown.Rendering.Action],
            hasHead: Bool,
            hasBody: Bool
        ) {
            self.head = head
            self.body = body
            self.hasHead = hasHead
            self.hasBody = hasBody
        }
    }
}

extension Markdown.Rendering.Table {
    public static var `default`: Self {
        .init { input in
            var actions: [Render.Action] = []
            actions.append(.push(.element(tagName: "table", isBlock: true, isVoid: false, isPreElement: false)))
            if input.hasHead {
                actions.append(.push(.element(tagName: "thead", isBlock: true, isVoid: false, isPreElement: false)))
                actions.append(.push(.element(tagName: "tr", isBlock: true, isVoid: false, isPreElement: false)))
                actions.append(contentsOf: input.head)
                actions.append(.pop(.element(isBlock: true)))
                actions.append(.pop(.element(isBlock: true)))
            }
            if input.hasBody {
                actions.append(.push(.element(tagName: "tbody", isBlock: true, isVoid: false, isPreElement: false)))
                actions.append(contentsOf: input.body)
                actions.append(.pop(.element(isBlock: true)))
            }
            actions.append(.pop(.element(isBlock: true)))
            return actions
        }
    }
}
