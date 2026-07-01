# swift-markdown-html-render

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Renders Markdown to HTML as composable `HTML.View` values, with customizable per-element rendering, heading slugs, block directives, and table-of-contents extraction.

---

## Key Features

- **Renders to an `HTML.View`** — Markdown becomes a typed HTML view that composes inside any HTML document tree, not just a flat string.
- **Per-element rendering** — Override how headings, paragraphs, code blocks, lists, tables, and inline elements render through `Markdown.Rendering`.
- **Configurable heading slugs** — `Markdown.Configuration.SlugGenerator` offers `.default`, `.prefixed(_:)`, and `.custom(_:)` strategies, deduplicated across a document.
- **Block directives** — Handle custom `@Name(...)` directives with your own renderer via `Markdown.Configuration.Directives`.
- **Table of contents** — `Markdown.tableOfContents(from:)` extracts headings as `Section` values carrying id, level, and timestamp.
- **Transcript timestamps** — `@T(0:00) Speaker` directives parse into `Timestamp` values for time-coded content.
- **GitHub-flavored elements** — Tables, strikethrough, fenced code blocks with language and line-highlight info, and block-quote asides mapped to diagnostic levels.

---

## Quick Start

Markdown renders to a typed `HTML.View`, so it composes directly inside an HTML document alongside the rest of your view tree:

```swift
import Markdown_HTML_Rendering

let html = try String(
    Markdown {
        """
        # Changelog

        Version 2 adds **typed throws** end to end.

        - Composes into any HTML view tree
        - Custom per-element rendering
        """
    }
)
```

Headings followed by a `@T(...)` timestamp directive are collected into a table of contents:

```swift
let sections = Markdown.tableOfContents(from: """
    # Intro
    @T(0:00)
    Welcome.

    # Deep Dive
    @T(2:15)
    Details.
    """)
// sections[0].id == "intro"
// sections[0].timestamp?.duration == 0
```

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-markdown-html-render.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Markdown HTML Rendering", package: "swift-markdown-html-render")
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26.

---

## Architecture

Three library products. Importing `Markdown HTML Rendering` also brings the HTML rendering, CSS, and `SwiftMarkdown` parse types into scope.

| Product | When to import |
|---------|----------------|
| `Markdown HTML Rendering` | Rendering Markdown to HTML — the `Markdown` view, `Markdown.Configuration`, `Markdown.Rendering`, and `Markdown.tableOfContents(from:)`. |
| `Markdown HTML Rendering Test Support` | Test targets that render Markdown and assert against the output; re-exports the main module and Swift Testing. |
| `Markdown Previews` | Xcode `#Preview` gallery of rendered Markdown elements (SwiftUI; macOS and iOS only). |

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public flip.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).
