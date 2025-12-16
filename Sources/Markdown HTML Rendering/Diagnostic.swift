public import HTML_Rendering
public import CSS_HTML_Rendering
public import CSS_Theming
public import Dependencies

public struct Diagnostic<Message: HTML.View>: HTML.View {
    let level: DiagnosticLevel
    let message: Message

    public init(level: DiagnosticLevel, @HTML.Builder message: () -> Message) {
        self.level = level
        self.message = message()
    }

    public var body: some HTML.View {
        ContentDivision() {
            HStack(spacing: 0) {
                ContentDivision() {
                    ContentDivision() {
                        level.icon
                    }
                    .css
                    .inlineStyle(
                        Filter.property,
                        """
                        drop-shadow(1px 0 0 white) \
                        drop-shadow(-1px 0 0 white) \
                        drop-shadow(0 1px 0 white) \
                        drop-shadow(0 -1px 0 white)
                        """
                    )
                    .width(.px(14))
                }
                .css
                .color(level.iconColor)
                .backgroundColor(level.backgroundColor)
                .padding(Padding.sides(top: .px(8), right: .px(8), bottom: .px(7), left: .px(8)))

                ContentDivision() {
                    VStack(spacing: 0.5.rem) {
                        message
                    }
                    .class("diagnostic")
                }
                .css
                .backgroundColor(level.detailBackgroundColor)
                //                .color(.black.withDarkColor(.white))
                .flexGrow()
                .padding(.px(8))
            }
            .css
            .borderRadius(.uniform(.px(8)))
            .border(
                width: .px(0.5),
                style: .solid,
                color: .init(light: .hex("\(level.backgroundColor.light)44"))
            )
            .dark {
                $0.border(
                    width: .px(0.5),
                    style: .solid,
                    color: .init(light: .hex("\(level.backgroundColor.dark)44"))
                )
            }
            .overflow(Overflow.hidden)
        }
        .css
        .inlineStyle(
            "filter",
            """
            drop-shadow(0 0 2px rgba(0,0,0,0.2)) \
            drop-shadow(0 1px 0 rgba(0,0,0,0.2))
            """
        )
    }
}



// SwiftUI Preview removed - uses swift-html specific features not available in swift-html-rendering
