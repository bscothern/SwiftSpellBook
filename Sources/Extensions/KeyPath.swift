//
//  KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// Allows you to invert the value of a `KeyPath` to a `Bool` value by turning it into a function that does so.
///
/// - Parameter keyPath: The `KeyPath` to look up and invert when the returned function is executed.
/// - Returns: A function that inverts the `Bool` value found at a `KeyPath` of the `Root`.
@inlinable
public prefix func ! <Root>(keyPath: KeyPath<Root, Bool>) -> (Root) -> Bool {
    { !$0[keyPath: keyPath] }
}

/// Creates a function that compares the value at a `KeyPath` to a value.
///
/// - Parameters:
///   - lhs: The `KeyPath` to follow on the root and compare against `rhs`.
///   - rhs: The value to compare against the value found at the `lhs` path of the input `Root.`
/// - Returns: A function that compares a value of a `Root` to value.
@inlinable
public func == <Root, Value>(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool where Value: Equatable {
    { root in
        root[keyPath: lhs] == rhs
    }
}
