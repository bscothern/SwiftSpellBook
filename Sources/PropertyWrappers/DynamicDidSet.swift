//
//  DynamicDidSet.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A property wrapper that allows you to customize the didSet property observer at runtime.
@propertyWrapper
public struct DynamicDidSet<WrappedValue>: MutablePropertyWrapper {
    /// The function type called on `didSet` operations of the `wrappedValue`.
    ///
    /// - Important: This must not cause another setting of the same property this is tied to.
    ///
    /// - Parameters:
    ///   - value: The new value of `wrappedValue`.
    ///   - oldValue: The previous value of `wrappedValue`.
    public typealias DidSet = (_ value: WrappedValue, _ oldValue: WrappedValue) -> Void

    public var wrappedValue: WrappedValue {
        didSet {
            didSet?(wrappedValue, oldValue)
        }
    }

    @inlinable
    public var projectedValue: Self {
        get { self }
        set { self = newValue }
        _modify {
            defer { _fixLifetime(self) }
            yield &self
        }
    }

    /// The `DidSet` function to call when the `wrappedValue`'s didSet property observer triggers.
    public var didSet: DidSet?

    /// Create a `DynamicDidSet`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `DynamicDidSet`.
    ///   - didSet: The function to call when the `wrappedValue`'s didSet property observer triggers.
    @inlinable
    public init(
        wrappedValue: WrappedValue,
        didSet: DidSet? = nil
    ) {
        self.wrappedValue = wrappedValue
        self.didSet = didSet
    }
}
