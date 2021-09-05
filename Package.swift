// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "DangerSwiftJira",
    products: [
        .library(
            name: "DangerSwiftJira",
            targets: ["DangerSwiftJira"]
        ),
        .library(name: "DangerDependencies", type: .dynamic, targets: ["DangerDependencies"]),
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.43.0")),
        .package(name: "DangerSwiftCoverage", url: "https://github.com/f-meloni/danger-swift-coverage", .upToNextMajor(from: "1.2.1")),
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["danger-swift", "DangerSwiftCoverage"]),
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
