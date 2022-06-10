// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "qBittorrentKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "qBittorrentKit",
            targets: ["qBittorrent"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
    ],
    targets: [
        .target(
            name: "qBittorrent",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "UnitTests",
            dependencies: ["qBittorrent"]),
        .testTarget(
            name: "IntegrationTests",
            dependencies: ["qBittorrent"],
            resources: [
                .process("Resources")
            ]),
    ]
)
