// swift-tools-version:6.2

import PackageDescription

extension String {
    static let htmlMarkdown: Self = "HTMLMarkdown"
}

extension Target.Dependency {
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var htmlTheme: Self { .product(name: "HTMLTheme", package: "swift-html") }
    static var swiftMarkdown: Self { .product(name: "Markdown", package: "swift-markdown") }
    static var markdownBuilder: Self { .product(name: "MarkdownBuilder", package: "swift-builders") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var orderedCollections: Self { .product(name: "OrderedCollections", package: "swift-collections") }
    static var htmlRenderableTestSupport: Self { .product(name: "HTML Renderable TestSupport", package: "swift-html-rendering") }
}

let package = Package(
    name: "swift-html-markdown",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .watchOS(.v11),
        .macCatalyst(.v18)
    ],
    products: [
        .library(name: .htmlMarkdown, targets: [.htmlMarkdown])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html.git", from: "0.1.0"),
        .package(url: "https://github.com/coenttb/swift-html-rendering.git", from: "0.1.0"),
        .package(url: "https://github.com/swiftlang/swift-markdown", from: "0.4.0"),
        .package(url: "https://github.com/coenttb/swift-builders", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.2"),
    ],
    targets: [
        .target(
            name: .htmlMarkdown,
            dependencies: [
                .html,
                .htmlTheme,
                .swiftMarkdown,
                .markdownBuilder,
                .dependencies,
                .orderedCollections
            ]
        ),
        .testTarget(
            name: .htmlMarkdown.tests,
            dependencies: [
                .target(name: .htmlMarkdown),
                .htmlRenderableTestSupport
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { "\(self) Tests" }
}
