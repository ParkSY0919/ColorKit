// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestApp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
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