// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    dependencies: [
        .package(path: "../LocalDatabase")
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: [
                .product(
                    name: "LocalDatabase",
                    package: "LocalDatabase"
                )
            ]
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        )
    ]
)
