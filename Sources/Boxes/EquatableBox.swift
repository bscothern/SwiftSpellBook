//
//  EquatableBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

/// A `Box` that a custom implimentation that allows a custom implimentation `Equatable` for the contained type.
///
/// - Important: When the `==` operator is caled on this type it will use the `lhs` box equality function.
@dynamicMemberLookup
public struct EquatableBox<Value>: MutableBox, Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality.
    /// For any values `a` and `b`, `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public typealias AreEqualFunction = (_ lhs: Value, _ rhs: Value) -> Bool

    public var boxedValue: Value

    /// The `AreEqualFunction` used by this box for equality checks if it is the `lhs` argument of the `==` operator.
    public let areEqual: AreEqualFunction

    /// Creates an `EquatableBox`.
    ///
    /// - Parameters:
    ///   - boxedValue: The inital value in the `Box`.
    ///   - areEqual: The function to use for `Equatable` operations.
    @inlinable
    public init(
        _ boxedValue: Value,
        areEqualBy areEqual: @escaping AreEqualFunction
    ) {
        self.boxedValue = boxedValue
        self.areEqual = areEqual
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.areEqual(lhs.boxedValue, rhs.boxedValue)
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
