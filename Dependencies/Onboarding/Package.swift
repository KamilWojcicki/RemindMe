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
    
    ],
    targets: [
        .target(
            name: "OnboardingInterface",
            dependencies: [
                
            ]
        ),
        .target(
            name: "Onboarding",
            dependencies: [
                "OnboardingInterface"
            ]
        ),
        .testTarget(
            name: "OnboardingTests",
            dependencies: ["Onboarding"]
        )
    ]
)
