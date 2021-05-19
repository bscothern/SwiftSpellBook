//
//  CustomEquatable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import SwiftBoxesSpellBook

/// A property wrapper that lets you customize the `Equatable` conformance of its `wrappedValue`.
///
/// - Important:
///     The `==` operator is left hand assoicated meaning that 2 instance of this property wrapper will prefer to use the left hand side's `==` operator.
@propertyWrapper
public struct CustomEquatable<WrappedValue>: MutablePropertyWrapper, Equatable {
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
    var box: EquatableBox<WrappedValue>

    /// Creates a `CustomEquatable`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `CustomEquatable`.
    ///   - areEqual: The function to use for `Equatable` conformance.
    @inlinable
    public init(
        wrappedValue: WrappedValue,
        areEqualBy areEqual: @escaping (WrappedValue, WrappedValue) -> Bool
    ) {
        box = .init(wrappedValue, areEqualBy: areEqual)
    }
}
