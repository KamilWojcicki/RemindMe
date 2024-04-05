// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DependencyInjection",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            exact: "2.8.4"
        )
    ],
    targets: [
        .target(
            name: "DependencyInjection",
            dependencies: [
                .product(
                    name: "Swinject",
                    package: "Swinject"
                )
            ]
        ),
        .testTarget(
            name: "DependencyInjectionTests",
            dependencies: ["DependencyInjection"]),
    ]
)
