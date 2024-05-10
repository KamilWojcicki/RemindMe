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
        .package(path: "../Navigation"),
        .package(path: "../ToDo")
    ],
    targets: [
        .target(
            name: "HomeInterface",
            dependencies: [
                .product(
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "ToDo",
                    package: "ToDo"
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
