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
        .package(path: "Animation"),
        .package(path: "Components"),
        .package(path: "DependencyInjection"),
        .package(path: "Design"),
        .package(path: "Localizations"),
        .package(path: "Navigation"),
        .package(path: "ToDo")
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(
                    name: "Animation",
                    package: "Animation"
                ),
                .product(
                    name: "Components",
                    package: "Components"
                ),
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
                .product(
                    name: "Design",
                    package: "Design"
                ),
                .product(
                    name: "Localizations",
                    package: "Localizations"
                ),
                .product(
                    name: "Navigation",
                    package: "Navigation"
                ),
                .product(
                    name: "ToDo",
                    package: "ToDo"
                )
            ]
        )
    ]
)
