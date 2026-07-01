import CSS_HTML_Rendering
import CSS_Theming
import HTML_Rendering

extension Markdown.Rendering {
    public struct ThematicBreak: Sendable {
        public var render: @Sendable () -> [Render.Action]

        public init(render: @escaping @Sendable () -> [Render.Action]) {
            self.render = render
        }
    }
}

extension Markdown.Rendering.ThematicBreak {
    private static let cached = Markdown.Rendering.capture {
        ContentDivision {
            HTML_Rendering.ThematicBreak()
                .css
                .borderRight(BorderRight.none)
                .borderBottom(BorderBottom.none)
                .borderLeft(BorderLeft.none)
                .borderTop(.init(width: .px(1), style: .solid, color: .gray500))
                .margin(Margin.sides(vertical: .zero, horizontal: .percent(30)))
        }
        .css
        .marginTop(MarginTop.rem(1))
        .marginBottom(MarginBottom.rem(2))
    }

    public static var `default`: Self {
        .init { cached }
    }
}
