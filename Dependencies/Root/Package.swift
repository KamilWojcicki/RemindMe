// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Root",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Root",
            targets: ["Root"]
        ),
        .library(
            name: "RootInterface",
            targets: ["RootInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "RootInterface",
            dependencies: [
                
            ]
        ),
        .target(
            name: "Root",
            dependencies: [
                "RootInterface",
                .product(
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .testTarget(
            name: "RootTests",
            dependencies: ["Root"]),
    ]
)
