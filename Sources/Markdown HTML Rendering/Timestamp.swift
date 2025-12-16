//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

public struct Timestamp: HTML.View {
    public var hour: Int
    public var minute: Int
    public var second: Int
    public var speaker: String?

    public init?(format: String, speaker: String?) {
        let components = format.split(separator: ":")
        guard let second = components.last.flatMap({ Int($0) }) else { return nil }
        self.hour = components.dropLast(2).last.flatMap { Int($0) } ?? 0
        self.minute = components.dropLast().last.flatMap { Int($0) } ?? 0
        self.second = second
        self.speaker = speaker
    }

    public var duration: Int {
        hour * 60 * 60 + minute * 60 + second
    }

    public var id: String {
        "t\(duration)"
    }

    public var anchor: String {
        "#\(id)"
    }

    public func formatted() -> String {
        var formatted = hour > 0 ? "\(hour):" : ""
        formatted.append("\(hour > 0 && minute < 10 ? "0" : "")\(minute):")
        formatted.append("\(second < 10 ? "0" : "")\(second)")
        return formatted
    }

    public var body: some HTML.View {
        ContentDivision {
            if let speaker {
                StrongImportance {
                    HTML.Text(speaker)
                }
                .css
                .color(DarkModeColor.gray500)
                .fontSize(FontSize.rem(0.875))
                .inlineStyle("text-transform", "uppercase")
                .desktop {
                    $0.lineHeight(1)
                        .position(.relative)
                        .top(Top.rem(0.5))
                }
            }

            let duration = self.duration
            ContentDivision {
                ContentDivision {
                    Anchor(href: .init(value: anchor)) {
                        HTML.Text(formatted())
                    }
                    .attribute("data-timestamp", "\(duration)")
                    .css
                    .color(DarkModeColor.gray800.withDarkColor(.gray300))
                }
                .id(id)
                .css
                .fontSize(FontSize.small)
                .textDecoration(TextDecoration.none)
                .inlineStyle("font-variant-numeric", "tabular-nums")
                .desktop {
                    $0.marginLeft(MarginLeft.rem(-4))
                        .lineHeight(3)
                        .position(.absolute)
                        .textAlign(.right)
                        .width(Width.rem(3.25))
                }
            }
        }
        .css
        .mobile {
            $0.display(Display.flex)
                .flexDirection(FlexDirection.columnReverse)
                .rowGap(RowGap.length(.rem(0.5)))
        }
    }
}
