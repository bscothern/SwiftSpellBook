//
//  OnDeinitCOW.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/5/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A property wrapper that ties a deinit function to the lifetime of its `WrappedValue` with copy on write semantics.
///
/// This is extra helpful when you want to use a pointer in a struct type.
///
/// - Important: This is a copy on write (COW) variation of `@OnDeinit` which requires manual copying if desired.
///     Like `@OnDeinit` it is backed by a class to trigger its `DeinitAction`.
///     Because this is copy on write that means that both the `wrappedValue` and `DeinitAction` will be copied into a new instance according to normal COW rules for mutations of `wrappedValue`.
@propertyWrapper
public struct OnDeinitCOW<WrappedValue>: MutablePropertyWrapper {
    /// The function that is called when this property wrapper goes out of scope.
    ///
    /// - Parameter wrappedValue: The final value contained in `wrappedValue` when `deinit` is triggered.
    public typealias DeinitAction = OnDeinit<WrappedValue>.DeinitAction

    @inlinable
    public var wrappedValue: WrappedValue {
        get { onDeinit.wrappedValue }
        set {
            onDeinit.unsafeMakeUnique()
            onDeinit.wrappedValue = newValue
        }
        _modify {
            defer { _fixLifetime(self) }
            onDeinit.unsafeMakeUnique()
            yield &onDeinit.wrappedValue
        }
    }

    @usableFromInline
    var onDeinit: OnDeinit<WrappedValue>

    /// Creates an `@OnDeinitCOW`.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the `wrappedValue` property.
    ///   - deinitAction: The function that should be called when this property wrapper goes out of scope.
    @inlinable
    @_transparent
    public init(wrappedValue: WrappedValue, do deinitAction: @escaping DeinitAction) {
        self.onDeinit = .init(wrappedValue: wrappedValue, do: deinitAction)
    }
}
