// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ToDo",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ToDo",
            targets: ["ToDo"]
        ),
        .library(
            name: "ToDoInterface",
            targets: ["ToDoInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(path: "../LocalDatabase")
    ],
    targets: [
        .target(
            name: "ToDoInterface",
            dependencies: [
                .product(
                    name: "LocalDatabase",
                    package: "LocalDatabase"
                )
            ]
        ),
        .target(
            name: "ToDo",
            dependencies: [
                "ToDoInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .testTarget(
            name: "ToDoTests",
            dependencies: ["ToDo"]
        )
    ]
)
