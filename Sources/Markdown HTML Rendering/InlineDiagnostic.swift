//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

public import HTML_Rendering
public import CSS_HTML_Rendering
public import CSS_Theming
public import Dependencies

public struct InlineDiagnostic: HTML.View {
    let level: DiagnosticLevel
    let message: String

    public var body: some HTML.View {
        VStack(alignment: .normal) {
            HStack(spacing: 0.05.rem) {
                ContentDivision() {
                    ContentDivision() {
                        level.icon
                    }
                    .css
                    .inlineStyle(
                        "filter",
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
                .padding(Padding.sides(top: .px(4), right: .px(10), bottom: .px(3), left: .px(10)))

                ContentDivision() {
                    HTML.Text(message)
                }
                .css
                .backgroundColor(level.backgroundColor)
                //                .color(.black.withDarkColor(.white))
                .title(message)
                .css
                .minWidth(0)
                .maxWidth(.px(500))
                .flexGrow(1)
                .flexShrink(1)
                .flexBasis(FlexBasis.auto)
                .padding(Padding.sides(top: .px(3), right: .px(30), bottom: .px(3), left: .px(8)))
                .inlineStyle("text-overflow", "ellipsis")
                .overflow(Overflow.hidden)
                .inlineStyle("white-space", "nowrap")
            }
            .css
            .inlineStyle("border-radius", "3px 0 0 3px")
            .overflow(Overflow.hidden)
        }
    }
}
