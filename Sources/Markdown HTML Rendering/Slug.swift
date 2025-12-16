//
//  File.swift
//  swift-markdown-html-rendering
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2025.
//

import HTML_Rendering
import CSS_HTML_Rendering
import CSS_Theming
import Dependencies

struct Slug: Hashable {
    var name: String
    var generation: Int
}

extension Set<Slug> {
    func slug(for string: String) -> String {
        var slug = Slug(name: string.slug(), generation: 0)
        while contains(slug) {
            slug.generation += 1
        }
        return "\(slug.name)\(slug.generation > 0 ? "-\(slug.generation)" : "")"
    }
}

extension String {
    func slug() -> String {
        split(whereSeparator: { !$0.isLetter && !$0.isNumber }).joined(separator: "-").lowercased()
    }
}
