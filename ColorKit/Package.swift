// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ColorKit",
            targets: ["ColorKit"]
        ),
        .plugin(
            name: "ColorKitPlugin",
            targets: ["ColorKitPlugin"]
        ),
    ],
    targets: [
        .target(
            name: "ColorKit",
            dependencies: []
        ),
        .executableTarget(
            name: "ColorGenerator",
            dependencies: [],
            path: "Sources/ColorGenerator"
        ),
        .plugin(
            name: "ColorKitPlugin",
            capability: .buildTool(),
            dependencies: ["ColorGenerator"],
            path: "Plugins/ColorKitPlugin"
        ),
        .testTarget(
            name: "ColorKitTests",
            dependencies: ["ColorKit"]
        ),
    ]
)
