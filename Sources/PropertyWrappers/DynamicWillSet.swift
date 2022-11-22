//
//  DynamicOnSet.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

/// A property wrapper that allows you to customize the willSet property observer at runtime.
@propertyWrapper
public struct DynamicWillSet<WrappedValue>: MutablePropertyWrapper {
    /// The function type called on `willSet` operations of the `wrappedValue`.
    ///
    /// - Important: This must not cause another setting of the same property this is tied to.
    ///
    /// - Parameters:
    ///   - value: The current value of `wrappedValue`.
    ///   - newValue: The new value of `wrappedValue`.
    public typealias WillSet = (_ value: WrappedValue, _ newValue: WrappedValue) -> Void

    public var wrappedValue: WrappedValue {
        willSet {
            willSet?(wrappedValue, newValue)
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

    /// The `WillSet` function to call when `wrappedValue`'s willSet property observer triggers.
    public var willSet: WillSet?

    /// Create a `DynamicWillSet`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `DynamicWillSet`.
    ///   - willSet: The function to call when the `wrappedValue`'s willSet property observer triggers.
    @inlinable
    public init(
        wrappedValue: WrappedValue,
        willSet: WillSet? = nil
    ) {
        self.wrappedValue = wrappedValue
        self.willSet = willSet
    }
}
