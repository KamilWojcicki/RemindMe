// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Onboarding",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]
        ),
        .library(
            name: "OnboardingInterface",
            targets: ["OnboardingInterface"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Design")
    ],
    targets: [
        .target(
            name: "OnboardingInterface",
            dependencies: [
                .product(
                    name: "Design",
                    package: "Design"
                )
            ]
        ),
        .target(
            name: "Onboarding",
            dependencies: [
                "OnboardingInterface",
                .product(
                    name: "Components",
                    package: "Components"
                )
            ]
        ),
        .testTarget(
            name: "OnboardingTests",
            dependencies: ["Onboarding"]
        )
    ]
)
