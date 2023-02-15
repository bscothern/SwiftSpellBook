// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// These flags can be set in the environment or via the force flag here.
// They are used to test language features, implimentations, and to allow code to exists that currenlty doesn't work but should.
enum ExperimentalFlags: String {
    // Provides @OnDeinitBuffered which is the same as @OnDeinit but backed by SafeManagedBuffer
    case propertyWrapper_OnDeinitBuffered = "PROPERTYWRAPPER_ON_DEINIT_BUFFERED"
    // Provides @_FromKeyPath like @_FromReferenceWritableKeyPath.
    // Currently causes a compiler error but it should work ¯\_(ツ)_/¯
    case propertyWrapper_FromKeyPath = "PROPERTYWRAPPER_FROM_KEY_PATH"
}

let experimentalFlags: [(flag: ExperimentalFlags, force: Bool)] = [
    (flag: .propertyWrapper_OnDeinitBuffered, force: false),
    (flag: .propertyWrapper_FromKeyPath, force: false),
]

/// Controls the experimental defines to trigger those features for development.
let experimentalSwiftSettings: [ExperimentalFlags: SwiftSetting] = {
    func define(flag: ExperimentalFlags, force: Bool) -> SwiftSetting? {
        guard ProcessInfo.processInfo.environment[flag.rawValue] != nil || force else {
            return nil
        }
        return .define(flag.rawValue)
    }

    return .init(
        uniqueKeysWithValues: experimentalFlags.lazy
            .map { flag, force in
                (flag, define(flag: flag, force: force))
            }
            .compactMap { flag, define in
                guard let define = define else {
                    return nil
                }
                return (flag, define)
            }
    )
}()

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
            name: "SwiftFunctionSpellBook",
            targets: ["SwiftFunctionSpellBook"]
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
        .library(
            name: "XCTestSpellBook",
            targets: ["XCTestSpellBook"]
        ),
//        .executable(
//            name: "SwiftCollectionsSpellBookBenchmark",
//            targets: ["SwiftCollectionsSpellBookBenchmark"]
//        ),
    ],
    dependencies: [
        .package(path: "../swift-package-coverage"),
//        .package(
//            url: "https://github.com/apple/swift-collections-benchmark",
//            .upToNextMinor(from: "0.0.1")
//        ),
        .package(
            url: "https://github.com/loftware/CheckXCAssertionFailure",
            exact: "0.9.6"
        ),
        .package(
            url: "https://github.com/loftware/StandardLibraryProtocolChecks",
            exact: "0.1.2"
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
                .target(name: "SwiftFunctionSpellBook"),
                .target(name: "SwiftMemoryManagementSpellBook"),
                .target(name: "SwiftPropertyWrappersSpellBook"),
                .target(name: "SwiftResultBuildersSpellBook"),
            ],
            path: "Sources/Umbrella"
        ),
        .target(
            name: "SwiftBoxesSpellBook",
            path: "Sources/Boxes"
        ),
        .testTarget(
            name: "SwiftBoxesSpellBookTests",
            dependencies: [
                .target(name: "SwiftBoxesSpellBook"),
                .product(name: "LoftTest_CheckXCAssertionFailure", package: "CheckXCAssertionFailure"),
                .product(name: "LoftTest_StandardLibraryProtocolChecks", package: "StandardLibraryProtocolChecks"),
            ],
            path: "Tests/Boxes"
        ),
        .target(
            name: "SwiftCollectionsSpellBook",
            dependencies: [
                .target(name: "_AutoClosurePropertyWrapper"),
                .target(name: "SwiftMemoryManagementSpellBook"),
            ],
            path: "Sources/Collections"
        ),
        .testTarget(
            name: "SwiftCollectionsSpellBookTests",
            dependencies: [
                .target(name: "SwiftCollectionsSpellBook"),
                .product(name: "LoftTest_StandardLibraryProtocolChecks", package: "StandardLibraryProtocolChecks"),
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
                .target(name: "XCTestSpellBook"),
            ],
            path: "Tests/Foundation"
        ),
        .target(
            name: "SwiftFunctionSpellBook",
            dependencies: [
            ],
            path: "Sources/Function",
            exclude: [
                "GYB/"
            ]
//            plugins: [
//                .plugin(name: "swift-gyb-plugin", package: "swift-gyb-plugin"),
//            ]
        ),
        .testTarget(
            name: "SwiftFunctionSpellBookTests",
            dependencies: [
                .target(name: "SwiftFunctionSpellBook"),
                .target(name: "XCTestSpellBook"),
            ],
            path: "Tests/Function"
        ),
        .target(
            name: "SwiftMemoryManagementSpellBook",
            path: "Sources/MemoryManagement"
        ),
        .testTarget(
            name: "SwiftMemoryManagementSpellBookTests",
            dependencies: [
                .target(name: "SwiftMemoryManagementSpellBook"),
            ],
            path: "Tests/MemoryManagement"
        ),
        .target(
            name: "SwiftPropertyWrappersSpellBook",
            dependencies: [
                .target(name: "_Concurrency_PropertyWrappersSpellBook"),
                .target(name: "_PropertyWrapperProtocols"),
                .target(name: "SwiftBoxesSpellBook"),
            ] + {
                var experimentalDependencies: [Target.Dependency] = []
                if experimentalSwiftSettings.keys.contains(.propertyWrapper_OnDeinitBuffered) {
                    experimentalDependencies.append(.target(name: "SwiftMemoryManagementSpellBook"))
                }
                return experimentalDependencies
            }(),
            path: "Sources/PropertyWrappers",
            swiftSettings: Array(experimentalSwiftSettings.values)
        ),
        .testTarget(
            name: "SwiftPropertyWrappersSpellBookTests",
            dependencies: [
                .target(name: "SwiftPropertyWrappersSpellBook"),
            ],
            path: "Tests/PropertyWrappers"
        ),
        .target(
            name: "SwiftResultBuildersSpellBook",
            path: "Sources/ResultBuilders"
        ),
        .testTarget(
            name: "SwiftResultBuildersSpellBookTests",
            dependencies: [
                .target(name: "XCTestSpellBook"),
                .target(name: "SwiftResultBuildersSpellBook"),
            ],
            path: "Tests/ResultBuilders"
        ),
        .target(
            name: "_Concurrency_PropertyWrappersSpellBook",
            dependencies: [
                .target(name: "_PropertyWrapperProtocols"),
            ],
            path: "Sources/_Concurrency+PropertyWrappers"
        ),
        .testTarget(
            name: "Concurrency.PropertyWrappersSpellBookTests",
            dependencies: [
                .target(name: "_Concurrency_PropertyWrappersSpellBook"),
            ],
            path: "Tests/_Concurrency+PropertyWrappers"
        ),
        .target(
            name: "_AutoClosurePropertyWrapper",
            dependencies: [
                .target(name: "_PropertyWrapperProtocols"),
            ],
            path: "Sources/_AutoClosurePropertyWrapper"
        ),
        .testTarget(
            name: "AutoClosurePropertyWrapperTests",
            dependencies: [
                .target(name: "_AutoClosurePropertyWrapper"),
            ],
            path: "Tests/_AutoClosurePropertyWrapper"
        ),
        .target(
            name: "_PropertyWrapperProtocols",
            path: "Sources/_PropertyWrapperProtocols"
        ),
        .testTarget(
            name: "PropertyWrapperProtocolsTests",
            dependencies: [
                .target(name: "_PropertyWrapperProtocols"),
                .product(name: "LoftTest_CheckXCAssertionFailure", package: "CheckXCAssertionFailure"),
                .product(name: "LoftTest_StandardLibraryProtocolChecks", package: "StandardLibraryProtocolChecks"),
            ],
            path: "Tests/_PropertyWrapperProtocols",
            swiftSettings: Array(experimentalSwiftSettings.values)
        ),
        .target(
            name: "XCTestSpellBook",
            dependencies: [
                .target(name: "SwiftResultBuildersSpellBook"),
            ],
            path: "Sources/XCTestSpellBook",
            linkerSettings: [
                .linkedFramework("XCTest", .when(platforms: [.macOS, .iOS, .tvOS, .linux, .windows, .android])),
            ]
        ),
        .testTarget(
            name: "XCTestSpellBookTests",
            dependencies: [
                .target(name: "XCTestSpellBook"),
            ],
            path: "Tests/XCTestSpellBook"
        ),
//        // MARK: - Benchmark
//        .target(
//            name: "SwiftCollectionsSpellBookBenchmark",
//            dependencies: [
//                .target(name: "SwiftCollectionsSpellBook"),
//                .product(name: "CollectionsBenchmark", package: "swift-collections-benchmark"),
//            ],
//            path: "Benchmark/Collections"
//        )
    ]
)
