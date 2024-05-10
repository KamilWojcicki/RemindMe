// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]
        ),
        .library(
            name: "HomeInterface",
            targets: ["HomeInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "HomeInterface",
            dependencies: [
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                "HomeInterface",
                .product(
                    name: "Components",
                    package: "Components"
                )
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]
        )
    ]
)
