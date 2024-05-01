// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tasks",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Tasks",
            targets: ["Tasks"]
        ),
        .library(
            name: "TasksInterface",
            targets: ["TasksInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Navigation")
    ],
    targets: [
        .target(
            name: "TasksInterface",
            dependencies: [
                .product(
                    name: "Navigation",
                    package: "Navigation"
                )
            ]
        ),
        .target(
            name: "Tasks",
            dependencies: [
                "TasksInterface"
            ]
        ),
        .testTarget(
            name: "TasksTests",
            dependencies: ["Tasks"]
        )
    ]
)
