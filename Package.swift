// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "DangerSwiftJira",
    products: [
        .library(
            name: "DangerSwiftJira",
            targets: ["DangerSwiftJira"]
        ),
        .library(name: "DangerDep", type: .dynamic, targets: ["DangerDependencies"]),
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift", from: "3.0.0"),
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["danger-swift"]),
        .target(
            name: "DangerSwiftJira",
            dependencies: ["danger-swift"]
        ),
        .testTarget(
            name: "DangerSwiftJiraTests",
            dependencies: [
                "DangerSwiftJira",
                .product(name: "DangerFixtures", package: "danger-swift"),
            ]
        ),
    ]
)
