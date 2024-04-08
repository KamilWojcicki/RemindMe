// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dependencies",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Dependencies",
            targets: ["Dependencies"]
        ),
    ],
    dependencies: [
        .package(path: "Navigation")
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        )
    ]
)
