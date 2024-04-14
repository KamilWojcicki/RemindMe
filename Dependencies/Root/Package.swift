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
        .package(path: "../Navigation"),
        .package(path: "../Onboarding")
    ],
    targets: [
        .target(
            name: "RootInterface",
            dependencies: [
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
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
                    name: "Onboarding",
                    package: "Onboarding"
                )
            ]
        ),
        .testTarget(
            name: "RootTests",
            dependencies: ["Root"]),
    ]
)
