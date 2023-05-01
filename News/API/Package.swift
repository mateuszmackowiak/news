// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "API",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "API",
            targets: ["API"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "API",
            dependencies: []),
        .testTarget(
            name: "APITests",
            dependencies: ["API"],
            resources: [.copy("Resources/SampleArticlesResponse.json")]),
        .testTarget(
            name: "OnlineIntegrationTests",
            dependencies: ["API"]),
    ]
)
