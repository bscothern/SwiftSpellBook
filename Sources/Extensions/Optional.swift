//
//  Optional.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/23/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

// swiftformat:disable spaceAroundOperators
infix operator ?= : AssignmentPrecedence
// swiftformat:enable spaceAroundOperators

/// Assigns to an optional value if it is currently `nil`
///
/// - Parameters:
///   - lhs: The optional that should have `rhs` assigned to it if it is currently `nil`.
///   - rhs: The value that should be assigned to `lhs` if it is currently `nil`.
@inlinable
public func ?= <Value>(lhs: inout Value?, rhs: @autoclosure () -> Value) {
    // So this only works with one layer of optionality.
    // So if you have .some(nil) it will not set the value.
    if lhs == nil {
        lhs = rhs()
    }
}
