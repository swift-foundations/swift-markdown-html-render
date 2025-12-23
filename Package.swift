// swift-tools-version:6.2

import PackageDescription

extension Target.Dependency {
    static var htmlRendering: Self { .product(name: "HTML Rendering", package: "swift-html-rendering") }
    static var css: Self { .product(name: "CSS", package: "swift-css") }
    static var cssTheming: Self { .product(name: "CSS Theming", package: "swift-css") }
    static var appleSwiftMarkdown: Self { .product(name: "Markdown", package: "swift-markdown") }
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
        .library(name: "Markdown HTML Rendering", targets: ["Markdown HTML Rendering"]),
        .library(name: "Markdown Previews", targets: ["Markdown Previews"])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-css", from: "0.6.1"),
        .package(url: "https://github.com/coenttb/swift-html-rendering", from: "0.1.15"),
        .package(url: "https://github.com/swiftlang/swift-markdown", from: "0.4.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.2"),
    ],
    targets: [
        // Internal target that re-exports swift-markdown as SwiftMarkdown namespace
        .target(
            name: "SwiftMarkdown",
            dependencies: [
                .appleSwiftMarkdown
            ]
        ),
        .target(
            name: "Markdown HTML Rendering",
            dependencies: [
                .htmlRendering,
                .css,
                .cssTheming,
                "SwiftMarkdown",
                .orderedCollections
            ]
        ),
        .target(
            name: "Markdown Previews",
            dependencies: [
                "Markdown HTML Rendering"
            ]
        ),
        .testTarget(
            name: "Markdown HTML Rendering".tests,
            dependencies: [
                .target(name: "Markdown HTML Rendering"),
                .htmlRenderableTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { "\(self) Tests" }
}
