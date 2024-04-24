// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]),
        .library(
            name: "Utility",
            targets: ["Utility"]),
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "Home",
            targets: ["Home"]),
        .library(
            name: "MediaList",
            targets: ["MediaList"]),
        .library(
            name: "MediaDetails",
            targets: ["MediaDetails"]),
        .library(
            name: "Favorites",
            targets: ["Favorites"]),
        .library(
            name: "Shared",
            targets: ["Shared"])
    ],
    dependencies: [
        .package(url: "https://github.com/SvenTiigi/YouTubePlayerKit.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "1.9.3"))
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                "Utility",
            ]),
        .target(
            name: "Utility",
            dependencies: [],
            resources: [.process("Resources/Colors.xcassets")]),
        .target(
            name: "Networking",
            dependencies: ["Utility", "Models"]),
        .target(
            name: "Shared",
            dependencies: ["Utility", "Models"]),
        .target(
            name: "MediaDetails",
            dependencies: [
                "Models",
                "Utility",
                "Shared",
                "Networking",
                .product(name: "YouTubePlayerKit", package: "YouTubePlayerKit"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "MediaList",
            dependencies: [
                "Models",
                "Utility",
                "Shared",
                "Networking",
                "MediaDetails",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "Home",
            dependencies: [
                "Models",
                "Utility",
                "Shared",
                "Networking",
                "MediaDetails",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "Favorites",
            dependencies: [
                "Models",
                "Utility",
                "Shared",
                "Networking",
                "MediaDetails",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ])
    ]
)
