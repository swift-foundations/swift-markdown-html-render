//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import SwiftMarkdown
import CSS_Theming

extension SwiftMarkdown.BlockQuote {
    struct Style {
        var backgroundColor: DarkModeColor
        var borderColor: DarkModeColor

        init(blockName: String) {
            switch blockName {
            case "Warning", "Correction":
                self.backgroundColor = .background.warning
                self.borderColor = .border.warning
            case "Important":
                self.backgroundColor = .background.highlighted
                self.borderColor = .border.highlighted
            case "Announcement", "Tip":
                self.backgroundColor = .background.info
                self.borderColor = .border.info
            default:
                self.backgroundColor = .background.neutral
                self.borderColor = .border.neutral
            }
        }
    }
}


