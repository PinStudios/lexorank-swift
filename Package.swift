// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LexoRank",
    platforms: [.iOS(.v10), .macOS(.v10_10), .tvOS(.v10)],
    products: [
        .library(
            name: "LexoRank",
            targets: ["LexoRank"]),
    ],
    targets: [
        .target(
            name: "LexoRank",
            dependencies: []),
        .testTarget(
            name: "LexoRankTests",
            dependencies: ["LexoRank"]),
    ]
)
