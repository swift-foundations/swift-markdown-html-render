import CSS_HTML_Rendering
import CSS_Theming
import Dependencies
public import HTML_Rendering

public struct Diagnostic {
    let level: Diagnostic.Level

    public init(level: Diagnostic.Level) {
        self.level = level
    }
}

extension Diagnostic {
    public func callAsFunction<Message: HTML.View>(
        @HTML.Builder _ message: () -> Message
    ) -> some HTML.View {
        ContentDivision {
            HStack(spacing: 0) {
                ContentDivision {
                    ContentDivision {
                        self.level.icon
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
                .color(self.level.iconColor)
                .backgroundColor(self.level.backgroundColor)
                .padding(Padding.sides(top: .px(8), right: .px(8), bottom: .px(7), left: .px(8)))

                ContentDivision {
                    VStack(spacing: 0.5.rem) {
                        message()
                    }
                    .class("diagnostic")
                }
                .css
                .backgroundColor(self.level.detailBackgroundColor)
                //                .color(.black.withDarkColor(.white))
                .flexGrow()
                .padding(.px(8))
            }
            .css
            .borderRadius(.uniform(.px(8)))
            .border(
                width: .px(0.5),
                style: .solid,
                color: self.level.backgroundColor.opacity(0.27)
            )
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
