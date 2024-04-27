// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]),
    ],
    dependencies: [
        .package(path: "../Design")
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                .product(
                    name: "Design",
                    package: "Design"
                )
            ]
        ),
        .testTarget(
            name: "ComponentsTests",
            dependencies: ["Components"]
        )
    ]
)
