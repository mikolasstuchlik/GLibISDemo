// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GLibISDemo",
    dependencies: [
        .package(url: "https://github.com/mikolasstuchlik/SwiftGLib.git", .branch("demo-isdb")),
        .package(name: "IndexStoreDB", url: "https://github.com/apple/indexstore-db.git", .branch("main"))
    ],
    targets: [
        .target(name: "GLibISDemo",  dependencies: ["IndexStoreDB"]),
    ]
)
