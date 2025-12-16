// swift-tools-version:6.2

import PackageDescription

extension Target.Dependency {
    static var htmlRendering: Self { .product(name: "HTML Rendering", package: "swift-html-rendering") }
    static var cssHTMLRendering: Self { .product(name: "CSS HTML Rendering", package: "swift-css-html-rendering") }
    static var cssTheming: Self { .product(name: "CSS Theming", package: "swift-css") }
    static var swiftMarkdown: Self { .product(name: "Markdown", package: "swift-markdown") }
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
        .library(name: "Markdown HTML Rendering", targets: ["Markdown HTML Rendering"]),
        .library(name: "Markdown Previews", targets: ["Markdown Previews"])
    ],
    dependencies: [
        .package(path: "../swift-html-rendering"),
        .package(path: "../swift-css-html-rendering"),
        .package(path: "../swift-css"),
        .package(url: "https://github.com/swiftlang/swift-markdown", from: "0.4.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.2"),
    ],
    targets: [
        .target(
            name: "Markdown HTML Rendering",
            dependencies: [
                .htmlRendering,
                .cssHTMLRendering,
                .cssTheming,
                .swiftMarkdown,
                .dependencies,
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
