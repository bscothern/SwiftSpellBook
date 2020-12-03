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
            name: "SwiftConcurrencySpellBook",
            targets: ["SwiftConcurrencySpellBook"]
        ),
        .library(
            name: "SwiftExtensionsSpellBook",
            targets: ["SwiftExtensionsSpellBook"]
        ),
        .library(
            name: "SwiftMemoryManagementSpellBook",
            targets: ["SwiftMemoryManagementSpellBook"]
        ),
        .library(
            name: "SwiftOperatorsManagementSpellBook",
            targets: ["SwiftOperatorsManagementSpellBook"]
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
//        .package(url: "https://github.com/bscothern/ProtocolTests.git", .upToNextMinor(from: "0.2.0"))
        .package(path: "/Users/Braden/Documents/Programming/ProtocolTests")
    ],
    targets: [
        .target(
            name: "SwiftSpellBook",
            dependencies: [
                .target(name: "SwiftCollectionsSpellBook"),
                .target(name: "SwiftExtensionsSpellBook"),
                .target(name: "SwiftMemoryManagementSpellBook"),
                .target(name: "SwiftOperatorsManagementSpellBook"),
                .target(name: "SwiftPropertyWrappersSpellBook"),
                .target(name: "SwiftResultBuildersSpellBook"),
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
            name: "SwiftConcurrencySpellBook",
            dependencies: [
                .target(name: "_Concurrency_PropertyWrappersSpellBook"),
            ],
            path: "Sources/Concurrency"
        ),
        .testTarget(
            name: "SwiftConcurrencySpellBookTests",
            dependencies: [
                .target(name: "SwiftConcurrencySpellBook"),
            ],
            path: "Tests/Concurrency"
        ),
        .target(
            name: "SwiftExtensionsSpellBook",
            dependencies: [
            ],
            path: "Sources/Extensions"
        ),
        .testTarget(
            name: "SwiftExtensionsSpellBookTests",
            dependencies: [
                .target(name: "SwiftExtensionsSpellBook"),
            ],
            path: "Tests/Extensions"
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
            name: "SwiftOperatorsManagementSpellBook",
            dependencies: [],
            path: "Sources/Operators"
        ),
        .testTarget(
            name: "SwiftOperatorsManagementSpellBookTests",
            dependencies: [
                .target(name: "SwiftOperatorsManagementSpellBook")
            ],
            path: "Tests/Operators"
        ),
        .target(
            name: "SwiftPropertyWrappersSpellBook",
            dependencies: [
                .target(name: "_Concurrency_PropertyWrappersSpellBook"),
                .target(name: "_PropertyWrapperProtocols"),
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
        ),
        .target(
            name: "_Concurrency_PropertyWrappersSpellBook",
            dependencies: [
                .target(name: "_PropertyWrapperProtocols")
            ],
            path: "Sources/_Concurrency+PropertyWrappers"
        ),
        .target(
            name: "_PropertyWrapperProtocols",
            dependencies: [],
            path: "Sources/_PropertyWrapperProtocols"
        ),
    ]
)
