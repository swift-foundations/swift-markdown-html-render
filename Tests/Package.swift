// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "testing",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/swift-foundations/swift-testing.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-html-render.git", branch: "main", traits: ["Testing"]),
    ],
    targets: [
        .testTarget(
            name: "Markdown HTML Rendering Performance Tests",
            dependencies: [
                .product(name: "Markdown HTML Rendering", package: "swift-markdown-html-render"),
                .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Markdown HTML Rendering Performance Tests"
        ),
        .testTarget(
            name: "Markdown HTML Rendering Snapshot Tests",
            dependencies: [
                .product(name: "Markdown HTML Rendering", package: "swift-markdown-html-render"),
                .product(name: "HTML Rendering Core Test Support", package: "swift-html-render"),
                .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Markdown HTML Rendering Snapshot Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
