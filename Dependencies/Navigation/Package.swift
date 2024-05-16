// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
        .library(
            name: "NavigationInterface",
            targets: ["NavigationInterface"]
        )
    ],
    targets: [
        .target(
            name: "NavigationInterface"
        ),
        .target(
            name: "Navigation",
            dependencies: [
                "NavigationInterface"
            ]
        ),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"]
        ),
    ]
)
