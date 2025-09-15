// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestApp",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "TestApp",
            dependencies: ["ColorKit"],
            resources: [
                .copy("Resources/design-tokens")
            ]
        )
    ]
)