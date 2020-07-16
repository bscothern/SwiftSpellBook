// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThingsMissingFromSwift",
    products: [
        .library(
            name: "ThingsMissingFromSwift",
            targets: ["ThingsMissingFromSwift"]
        ),
        .library(
            name: "ThingsMissingFromSwiftCollections",
            targets: ["ThingsMissingFromSwiftCollections"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ThingsMissingFromSwift",
            dependencies: [
                "ThingsMissingFromSwiftCollections"
            ],
            path: "Sources/Umbrella"
        ),
        .target(
            name: "ThingsMissingFromSwiftCollections",
            dependencies: [],
            path: "Sources/Collections"
        ),
        .testTarget(
            name: "ThingsMissingFromSwiftTests",
            dependencies: ["ThingsMissingFromSwift"]
        )
    ]
)
