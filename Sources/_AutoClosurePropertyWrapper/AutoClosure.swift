//
//  AutoClosure.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 3/7/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

/// A property wrapper that captures its value in a closure.
///
/// This is handy when you have a case of needing a `() -> WrappedValue` that should be lazily ran.
/// It lets you abstract out that function call to a normal property via this property wrapper.
@propertyWrapper
public struct AutoClosure<WrappedValue>: PropertyWrapper, ProjectedPropertyWrapper {
    @usableFromInline
    let _wrappedValue: () -> WrappedValue

    @inlinable
    @_transparent
    public var wrappedValue: WrappedValue { _wrappedValue() }

    @inlinable
    public var projectedValue: Self { self }

    /// Creates an `AutoClosure` from a traditional closure that returns a `WrappedValue`.
    ///
    /// - Parameter wrappedValue: The closure that will be contained in this `AutoClosure`.
    @inlinable
    public init(wrappedValue: @escaping () -> WrappedValue) {
        _wrappedValue = wrappedValue
    }

    /// Creates an `AutoClosure` from an `@autoclosure` of `WrappedValue`
    ///
    /// - Parameter wrappedValue: The `WrappedValue` to turn into a `@autoclosure` and contain in this `AutoClosure`.
    @inlinable
    public init(wrappedValue: @escaping @autoclosure () -> WrappedValue) {
        _wrappedValue = wrappedValue
    }
}
