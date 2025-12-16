// swift-tools-version:6.2

import PackageDescription

extension String {
    static let markdownHTMLRendering: Self = "Markdown HTML Rendering"
}

extension Target.Dependency {
    static var htmlRendering: Self { .product(name: "HTML Rendering", package: "swift-html-rendering") }
    static var cssHTMLRendering: Self { .product(name: "CSS HTML Rendering", package: "swift-css-html-rendering") }
    static var cssTheming: Self { .product(name: "CSS Theming", package: "swift-css") }
    static var swiftMarkdown: Self { .product(name: "Markdown", package: "swift-markdown") }
    static var markdownBuilder: Self { .product(name: "MarkdownBuilder", package: "swift-builders") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var orderedCollections: Self { .product(name: "OrderedCollections", package: "swift-collections") }
    static var htmlRenderableTestSupport: Self { .product(name: "HTML Rendering TestSupport", package: "swift-html-rendering") }
}

let package = Package(
    name: "swift-markdown-html-rendering",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .macCatalyst(.v26)
    ],
    products: [
        .library(name: .markdownHTMLRendering, targets: [.markdownHTMLRendering])
    ],
    dependencies: [
        .package(path: "../swift-html-rendering"),
        .package(path: "../swift-css-html-rendering"),
        .package(path: "../swift-css"),
        .package(url: "https://github.com/swiftlang/swift-markdown", from: "0.4.0"),
        .package(url: "https://github.com/coenttb/swift-builders", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.2"),
    ],
    targets: [
        .target(
            name: .markdownHTMLRendering,
            dependencies: [
                .htmlRendering,
                .cssHTMLRendering,
                .cssTheming,
                .swiftMarkdown,
                .markdownBuilder,
                .dependencies,
                .orderedCollections
            ]
        ),
        .testTarget(
            name: .markdownHTMLRendering.tests,
            dependencies: [
                .target(name: .markdownHTMLRendering),
                .htmlRenderableTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { "\(self) Tests" }
}
