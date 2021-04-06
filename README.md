# SwiftSpellBook

A collection of common types and extensions to the Swift Standard Library and its preview/deveopment packages.

![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)
![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)
![Swift Versions](https://img.shields.io/badge/Swift-5.3-orange.svg)

## Adding `SwiftSpellBook` as a dependency
Add the following line to your package dependencies in your `Package.swift` file:
```swift
.package(url: "https://github.com/bscothern/SwiftSpellBook", .upToNextMinor(from: "0.1.0")),
```

Then in the targets section add this line as a dependency in your `Package.swift` file:
```swift
.product(name: "SwiftSpellBook", package: "SwiftSpellBook"),
```

It is recommended to use .upToNextMinor(from: "0.1.0") for the version number because this project will be source stable between minor versions until version 1.0.0 is reached.

## Submodules
If you want everything you can just use the umbrella module `SwiftSpellBook`.
If you don't want all of it then it has been broken into submodules that let you pick just pieces of the library if those are all you want.
This has also been done to enable better testing in isolation to make sure each piece works well.
There are a handful of them that depend on others but for the most part they are isolated.

* `SwiftBoxesSpellBook` - This has different `Box` types that can be used to add protocol implimentations to a type without adding a retroactive conformance which is considered bad practice.
* `SwiftCollectionsSpellBook` - This has different collection and sequence types and extensions to simplify working with them. This has extra support for KeyPaths and lazy operations.
* `SwiftConcurrencySpellBook` - This has different extensions and types to help with concurrency operations.
* `SwiftExtensionsSpellBook` - This adds some extensions to existing standard library types.
* `SwiftFoundationSpellBook` - This adds some extensions to `Foundation` library types.
* `SwiftMemoryManagementSpellBook` - This adds some types to help with manage memory when working with low level operations.
* `SwiftPropertyWrappersSpellBook` - This adds lots of property wrappers for all sorts of tasks.
* `SwiftResultBuildersSpellBook` - This adds different common result builders to use in your projects.
