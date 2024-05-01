// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Settings",
            targets: ["Settings"]
        ),
        .library(
            name: "SettingsInterface",
            targets: ["SettingsInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "SettingsInterface",
            dependencies: [
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        ),
        .target(
            name: "Settings",
            dependencies: [
                "SettingsInterface"
            ]
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["Settings"]
        )
    ]
)
