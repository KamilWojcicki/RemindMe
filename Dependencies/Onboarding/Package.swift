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
        .package(path: "../Animation"),
        .package(path: "../Components"),
        .package(path: "../Design"),
        .package(path: "../Localizations")
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
                    name: "Animation",
                    package: "Animation"
                ),
                .product(
                    name: "Components",
                    package: "Components"
                ),
                .product(
                    name: "Localizations",
                    package: "Localizations"
                )
            ]
        ),
        .testTarget(
            name: "OnboardingTests",
            dependencies: ["Onboarding"]
        )
    ]
)
