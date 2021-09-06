// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "DangerSwiftJira",
    products: [
        .library(name: "DangerSwiftJira", targets: ["DangerSwiftJira"]),
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
    ],
    dependencies: [
        .package(name: "danger-swift", url: "https://github.com/danger/swift", from: "3.0.0"),
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.43.0")), // dev
        .package(url: "https://github.com/shibapm/Rocket", .upToNextMajor(from: "1.2.0")), // dev
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: [.product(name: "Danger", package: "danger-swift")]), // dev
        .target(name: "DangerSwiftJira", dependencies: [.product(name: "Danger", package: "danger-swift")]),
        .testTarget(
            name: "DangerSwiftJiraTests",
            dependencies: [
                "DangerSwiftJira",
                .product(name: "DangerFixtures", package: "danger-swift"),
            ]
        ),
    ]
)
