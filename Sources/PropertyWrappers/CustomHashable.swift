//
//  CustomHashable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import SwiftBoxesSpellBook

/// A property wrapper that lets you customize the `Hashable` and `Equatable` conformances of its `wrappedValue`.
///
/// - Important:
///     The `==` operator is left hand assoicated meaning that 2 instance of this property wrapper will prefer to use the left hand side's `==` operator.
@propertyWrapper
public struct CustomHashable<WrappedValue>: MutablePropertyWrapper, Hashable {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { box.boxedValue }
        set { box.boxedValue = newValue }
        _modify {
            defer { _fixLifetime(self) }
            yield &box.boxedValue
        }
    }

    @usableFromInline
    var box: HashableBox<WrappedValue>

    /// Creates a `CustomHashable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `CustomEquatable`.
    ///   - areEqual: The function to use for `Equatable` conformance.
    ///   - hashFunction: The function to use for `Hashable` conformance.
    @inlinable
    public init(
        wrappedValue: WrappedValue,
        areEqualBy areEqual: @escaping (WrappedValue, WrappedValue) -> Bool,
        hashedBy hashFunction: @escaping (_ hasher: inout Hasher, _ value: WrappedValue) -> Void
    ) {
        box = .init(wrappedValue, areEqualBy: areEqual, hashedBy: hashFunction)
    }

    /// Creates a `CustomHashable` using the existing `Equatable` conformance of `WrappedValue`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `CustomEquatable`.
    ///   - hashFunction: The function to use for `Hashable` conformance.
    @inlinable
    public init(
        wrappedValue: WrappedValue,
        hashedBy hashFunction: @escaping (_ hasher: inout Hasher, _ value: WrappedValue) -> Void
    ) where WrappedValue: Equatable {
        self.init(wrappedValue: wrappedValue, areEqualBy: ==, hashedBy: hashFunction)
    }
}
