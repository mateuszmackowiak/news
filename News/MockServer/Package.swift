// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockServer",
    platforms: [.iOS(.v12), .macOS(.v10_15), .watchOS(.v4), .tvOS(.v11)],
    products: [
        .library(name: "MockServer", targets: ["MockServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio-http2.git", from: "1.26.0"),
    ],
    targets: [
        .target(name: "MockServer", dependencies: [
            .product(name: "NIOHTTP2", package: "swift-nio-http2"),
        ], path: "Sources"),
        .testTarget(name: "MockServerTests", dependencies: ["MockServer"], path: "Tests"),
    ]
)
