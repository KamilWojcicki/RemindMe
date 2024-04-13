// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Design",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Design",
            targets: ["Design"]
        ),
        .plugin(
            name: "Swiftgen",
            targets: ["Swiftgen"]
        )
    ],
    targets: [
        .target(
            name: "Design",
            dependencies: [],
            resources: [
                .process("Resources/")
            ]
        ),
        .plugin(
            name: "Swiftgen",
            capability: .command(
                intent: .custom(
                    verb: "run-swiftgen",
                    description: "Generates code based on tokens."
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "SwiftGen generates code based on tokens.")
                ]
            ),
            dependencies: [
                "swiftgen"
            ]
        ),
        .binaryTarget(
            name: "swiftgen",
            url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.6.2/swiftgen-6.6.2.artifactbundle.zip",
            checksum: "7586363e24edcf18c2da3ef90f379e9559c1453f48ef5e8fbc0b818fbbc3a045"
        )
    ]
)
