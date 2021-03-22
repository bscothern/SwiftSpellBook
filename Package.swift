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
            name: "SwiftBoxesSpellBook",
            targets: ["SwiftBoxesSpellBook"]
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
            name: "SwiftFoundationSpellBook",
            targets: ["SwiftFoundationSpellBook"]
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
        .package(
            name: "LoftTest_CheckXCAssertionFailure",
            url: "https://github.com/loftware/CheckXCAssertionFailure",
            from: "0.9.6"
        ),
        .package(
            name: "LoftTest_StandardLibraryProtocolChecks",
            url: "https://github.com/loftware/StandardLibraryProtocolChecks",
            .exact("0.1.0")
        ),
    ],
    targets: [
        .target(
            name: "SwiftSpellBook",
            dependencies: [
                .target(name: "SwiftBoxesSpellBook"),
                .target(name: "SwiftCollectionsSpellBook"),
                .target(name: "SwiftExtensionsSpellBook"),
                .target(name: "SwiftFoundationSpellBook"),
                .target(name: "SwiftMemoryManagementSpellBook"),
                .target(name: "SwiftPropertyWrappersSpellBook"),
                .target(name: "SwiftResultBuildersSpellBook"),
            ],
            path: "Sources/Umbrella"
        ),
        .target(
            name: "SwiftBoxesSpellBook",
            dependencies: [],
            path: "Sources/Boxes"
        ),
        .testTarget(
            name: "SwiftBoxesSpellBookTests",
            dependencies: [
                .target(name: "SwiftBoxesSpellBook"),
                .product(name: "LoftTest_CheckXCAssertionFailure", package: "LoftTest_CheckXCAssertionFailure"),
                .product(name: "LoftTest_StandardLibraryProtocolChecks", package: "LoftTest_StandardLibraryProtocolChecks"),
            ],
            path: "Tests/Boxes"
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
                .product(name: "LoftTest_StandardLibraryProtocolChecks", package: "LoftTest_StandardLibraryProtocolChecks"),
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
            name: "SwiftFoundationSpellBook",
            dependencies: [
            ],
            path: "Sources/Foundation"
        ),
        .testTarget(
            name: "SwiftFoundationSpellBookTests",
            dependencies: [
                .target(name: "SwiftFoundationSpellBook"),
            ],
            path: "Tests/Foundation"
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
                .target(name: "_Concurrency_PropertyWrappersSpellBook"),
                .target(name: "_PropertyWrapperProtocols"),
                .target(name: "SwiftBoxesSpellBook"),
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
        .testTarget(
            name: "Concurrency.PropertyWrappersSpellBookTests",
            dependencies: [
                .target(name: "_Concurrency_PropertyWrappersSpellBook")
            ],
            path: "Tests/_Concurrency+PropertyWrappers"
        ),
        .target(
            name: "_PropertyWrapperProtocols",
            dependencies: [],
            path: "Sources/_PropertyWrapperProtocols"
        ),
        .testTarget(
            name: "PropertyWrapperProtocolsTests",
            dependencies: [
                .target(name: "_PropertyWrapperProtocols"),
                .product(name: "LoftTest_CheckXCAssertionFailure", package: "LoftTest_CheckXCAssertionFailure"),
                .product(name: "LoftTest_StandardLibraryProtocolChecks", package: "LoftTest_StandardLibraryProtocolChecks"),
            ],
            path: "Tests/_PropertyWrapperProtocols"
        ),
    ]
)
