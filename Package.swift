// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSpellBook",
    products: [
        .library(
            name: "SwiftSpellBook",
            targets: ["SwiftSpellBook"]
        ),
        .library(
            name: "SwiftCollectionsSpellBook",
            targets: ["SwiftCollectionsSpellBook"]
        ),
        .library(
            name: "SwiftMemoryManagementSpellBook",
            targets: ["SwiftMemoryManagementSpellBook"]
        ),
        .library(
            name: "SwiftPropertyWrappersSpellBook",
            targets: ["SwiftPropertyWrappersSpellBook"]
        ),
        .library(
            name: "SwiftResultBuildersSpellBook",
            targets: ["SwiftResultBuildersSpellBook"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/bscothern/ProtocolTests.git", .upToNextMinor(from: "0.2.0"))
    ],
    targets: [
        .target(
            name: "SwiftSpellBook",
            dependencies: [
                .target(name: "SwiftCollectionsSpellBook"),
                .target(name: "SwiftMemoryManagementSpellBook"),
                .target(name: "SwiftPropertyWrappersSpellBook"),
                .target(name: "SwiftResultBuildersSpellBook")
            ],
            path: "Sources/Umbrella"
        ),
        .target(
            name: "SwiftCollectionsSpellBook",
            dependencies: [
                .target(name: "SwiftMemoryManagementSpellBook"),
            ],
            path: "Sources/Collections"
        ),
        .testTarget(
            name: "SwiftCollectionsSpellBookTests",
            dependencies: [
                .target(name: "SwiftCollectionsSpellBook"),
                .product(name: "ProtocolTests", package: "ProtocolTests")
            ],
            path: "Tests/Collections"
        ),
        .target(
            name: "SwiftMemoryManagementSpellBook",
            dependencies: [],
            path: "Sources/MemoryManagement"
        ),
        .testTarget(
            name: "SwiftMemoryManagementSpellBookTests",
            dependencies: [
                .target(name: "SwiftMemoryManagementSpellBook")
            ],
            path: "Tests/MemoryManagement"
        ),
        .target(
            name: "SwiftPropertyWrappersSpellBook",
            dependencies: [
                .target(name: "SwiftMemoryManagementSpellBook"),
            ],
            path: "Sources/PropertyWrappers"
        ),
        .testTarget(
            name: "SwiftPropertyWrappersSpellBookTests",
            dependencies: [
                .target(name: "SwiftPropertyWrappersSpellBook")
            ],
            path: "Tests/PropertyWrappers"
        ),
        .target(
            name: "SwiftResultBuildersSpellBook",
            dependencies: [],
            path: "Sources/ResultBuilders"
        ),
        .testTarget(
            name: "SwiftResultBuildersSpellBookTests",
            dependencies: [
                .target(name: "SwiftResultBuildersSpellBook")
            ],
            path: "Tests/ResultBuilders"
        )
    ]
)
