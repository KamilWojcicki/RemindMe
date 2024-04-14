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
        .package(path: "Root"),
//        .package(path: "Design")
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(
                    name: "Root",
                    package: "Root"
                ),
//                .product(
//                    name: "Design",
//                    package: "Design"
//                )
            ]
        )
    ]
)
