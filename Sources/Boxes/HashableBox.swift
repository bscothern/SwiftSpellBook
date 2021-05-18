//
//  HashableBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import Foundation

/// A `Box` that a custom implimentation that allows a custom implimentation `Hashable` for the contained type.
///
/// - Important: When the `==` operator is caled on this type it will use the `lhs` box equality function.
@dynamicMemberLookup
public struct HashableBox<Value>: MutableBox, Hashable {
    public typealias AreEqualFunction = EquatableBox<Value>.AreEqualFunction
    public typealias HashFunction = (_ hasher: inout Hasher, _ value: Value) -> Void

    public var boxedValue: Value {
        get { equatableBox.boxedValue }
        set { equatableBox.boxedValue = newValue }
        _modify {
            defer { _fixLifetime(self) }
            yield &equatableBox.boxedValue
        }
    }

    @usableFromInline
    var equatableBox: EquatableBox<Value>

    @usableFromInline
    let hashFunction: HashFunction
    
    /// Creates a `HashableBox`.
    ///
    /// - Parameters:
    ///   - boxedValue: The initial value of the `Box`.
    ///   - areEqual: The function to use for `Equtable` operations.
    ///   - hashFunction: The function to use for `Hashable` operations.
    @inlinable
    public init(
        _ boxedValue: Value,
        areEqualBy areEqual: @escaping AreEqualFunction,
        hashedBy hashFunction: @escaping HashFunction
    ) {
        self.init(customEquatable: .init(boxedValue, areEqualBy: areEqual), hashedBy: hashFunction)
    }

    /// Creates a `HashableBox`.
    ///
    /// - Parameters:
    ///   - equatableBox: An `EquatableBox<Value>` that contains the initial value of this `Box` and the `AreEqualFunction` to use for `Equtable` operations.
    ///   - hashFunction: The function to use for `Hashable` operations.
    @inlinable
    public init(
        customEquatable equatableBox: EquatableBox<Value>,
        hashedBy hashFunction: @escaping HashFunction
    ) {
        self.equatableBox = equatableBox
        self.hashFunction = hashFunction
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equatableBox == rhs.equatableBox
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hashFunction(&hasher, boxedValue)
    }

    public subscript<Result>(dynamicMember keyPath: KeyPath<Value, Result>) -> Result {
        boxedValue[keyPath: keyPath]
    }

    public subscript<Result>(dynamicMember keyPath: WritableKeyPath<Value, Result>) -> Result {
        get { boxedValue[keyPath: keyPath] }
        set { boxedValue[keyPath: keyPath] = newValue }
        _modify { yield &boxedValue[keyPath: keyPath] }
    }

    public subscript<Result>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Result>) -> Result {
        get { boxedValue[keyPath: keyPath] }
        set { boxedValue[keyPath: keyPath] = newValue }
        _modify { yield &boxedValue[keyPath: keyPath] }
    }
}
