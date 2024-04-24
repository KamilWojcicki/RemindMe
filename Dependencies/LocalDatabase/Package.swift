// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LocalDatabase",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LocalDatabase",
            targets: ["LocalDatabase"]
        ),
        .library(
            name: "LocalDatabaseInterface",
            targets: ["LocalDatabaseInterface"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.49.2")
    ],
    targets: [
        .target(
            name: "LocalDatabaseInterface",
            dependencies: [
                .product(
                    name: "RealmSwift",
                    package: "realm-swift"
                )
            ]
        ),
        .target(
            name: "LocalDatabase",
            dependencies: [
                "LocalDatabaseInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                )
            ]
        ),
        .testTarget(
            name: "LocalDatabaseTests",
            dependencies: ["LocalDatabase"]
        )
    ]
)
