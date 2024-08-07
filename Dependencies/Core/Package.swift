// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]
        ),
        .library(
            name: "CoreInterface",
            targets: ["CoreInterface"]
        )
    ],
    dependencies: [
    
    ],
    targets: [
        .target(
            name: "CoreInterface",
            dependencies: [
            
            ]
        ),
        .target(
            name: "Core",
            dependencies: [
                "CoreInterface"
            ]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        )
    ]
)
