// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Localizations",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Localizations",
            targets: ["Localizations"]
        ),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Localizations",
            dependencies: [],
            resources: [.process("Resources/")]
        )
    ]
)
