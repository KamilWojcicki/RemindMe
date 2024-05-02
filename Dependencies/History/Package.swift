// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "History",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "History",
            targets: ["History"]
        ),
        .library(
            name: "HistoryInterface",
            targets: ["HistoryInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "HistoryInterface",
            dependencies: [
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        ),
        .target(
            name: "History",
            dependencies: [
                "HistoryInterface"
            ]
        ),
        .testTarget(
            name: "HistoryTests",
            dependencies: ["History"]
        )
    ]
)
