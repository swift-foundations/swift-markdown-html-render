//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

struct BlockQuoteStyle {
    var backgroundColor: DarkModeColor
    var borderColor: DarkModeColor

    init(blockName: String) {
        switch blockName {
        case "Warning", "Correction":
            self.backgroundColor = DarkModeColor(light: .hex("FDF2F4"), dark: .hex("2E0402"))
            self.borderColor = DarkModeColor(light: .hex("D02C1E"), dark: .hex("EB4642"))
        case "Important":
            self.backgroundColor = DarkModeColor(light: .hex("FEFBF3"), dark: .hex("291F04"))
            self.borderColor = DarkModeColor(light: .hex("966922"), dark: .hex("F4B842"))
        case "Announcement", "Tip":
            self.backgroundColor = DarkModeColor(light: .hex("FBFFFF"), dark: .hex("0F2C2B"))
            self.borderColor = DarkModeColor(light: .hex("4B767C"), dark: .hex("9FFCE5"))
        case "Preamble":
            self.backgroundColor = DarkModeColor(light: .hex("FBF8FF"), dark: .hex("1e1925"))
            self.borderColor = DarkModeColor(light: .hex("8D51F6"), dark: .hex("8D51F6"))
        default:
            self.backgroundColor = DarkModeColor(light: .hex("f5f5f5"), dark: .hex("323232"))
            self.borderColor = DarkModeColor(light: .hex("696969"), dark: .hex("9a9a9a"))
        }
    }
}
