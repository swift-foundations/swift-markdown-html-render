// swift-tools-version: 6.4

import PackageDescription

extension String {
    static let markdownHTMLRendering: Self = "Markdown HTML Rendering"
    static let markdownPreviews: Self = "Markdown Previews"
    static let swiftMarkdown: Self = "SwiftMarkdown"
    var tests: Self { self + " Tests" }
}

extension Target.Dependency {
    static var markdownHTMLRendering: Self { .target(name: .markdownHTMLRendering) }
    static var markdownPreviews: Self { .target(name: .markdownPreviews) }
    static var swiftMarkdown: Self { .target(name: .swiftMarkdown) }
}

extension Target.Dependency {
    static var htmlRendering: Self {
        .product(name: "HTML Rendering", package: "swift-html-render")
    }
    static var css: Self {
        .product(name: "CSS", package: "swift-css")
    }
    static var cssTheming: Self {
        .product(name: "CSS Theming", package: "swift-css")
    }
    static var cssHTMLLayoutRendering: Self {
        .product(name: "CSS HTML Layout Rendering", package: "swift-css-html-layout-render")
    }
    static var appleSwiftMarkdown: Self {
        .product(name: "Markdown", package: "swift-markdown")
    }
    static var ownershipMutablePrimitives: Self {
        .product(name: "Ownership Mutable Primitives", package: "swift-ownership-primitives")
    }
    static var standardLibraryExtensions: Self {
        .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions")
    }
}

let package = Package(
    name: "swift-markdown-html-render",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: .markdownHTMLRendering, targets: [.markdownHTMLRendering]),
        .library(name: .markdownPreviews, targets: [.markdownPreviews]),
        .library(name: "Markdown HTML Rendering Test Support", targets: ["Markdown HTML Rendering Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-html-render.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-css.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-css-html-layout-render.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-markdown.git", from: "0.4.0"),
        .package(url: "https://github.com/swift-primitives/swift-ownership-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-standard-library-extensions.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .swiftMarkdown,
            dependencies: [
                .appleSwiftMarkdown,
            ]
        ),
        .target(
            name: .markdownHTMLRendering,
            dependencies: [
                .htmlRendering,
                .css,
                .cssTheming,
                .cssHTMLLayoutRendering,
                .swiftMarkdown,
                .ownershipMutablePrimitives,
                .standardLibraryExtensions,
            ]
        ),
        .target(
            name: .markdownPreviews,
            dependencies: [
                .markdownHTMLRendering,
            ]
        ),
        .target(
            name: "Markdown HTML Rendering Test Support",
            dependencies: [
                .markdownHTMLRendering,
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: .markdownHTMLRendering.tests,
            dependencies: [
                .markdownHTMLRendering,
            ],
            path: "Tests/Markdown HTML Rendering Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
