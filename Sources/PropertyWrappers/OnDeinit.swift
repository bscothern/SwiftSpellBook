//
//  OnDeinit.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property wrapper that ties a deinit function to the lifetime of its WrappedValue.
///
/// This is extra helpful when you want to use a pointer in a struct type.
@propertyWrapper
public final class OnDeinit<WrappedValue> {
    public var wrappedValue: WrappedValue

    @usableFromInline
    var deinitFunction: (WrappedValue) -> Void

    /// Creates an `@OnDeinit`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `wrappedValue` property.
    ///   - deinitFunction: The function that should be called when this property wrapper goes out of scope.
    ///   - wrappedValue: The final value contained in `wrappedValue` when `deinit` is triggered.
    @inlinable
    public init(wrappedValue: WrappedValue, do deinitFunction: @escaping (_ wrappedValue: WrappedValue) -> Void) {
        self.wrappedValue = wrappedValue
        self.deinitFunction = deinitFunction
    }

    @inlinable
    deinit {
        deinitFunction(wrappedValue)
    }
}

extension OnDeinit: PassThroughEquatablePropetyWrapper where WrappedValue: Equatable {}
extension OnDeinit: PassThroughHashablePropetyWrapper where WrappedValue: Hashable {}
extension OnDeinit: PassThroughComparablePropetyWrapper where WrappedValue: Comparable {}
