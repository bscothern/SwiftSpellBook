//
//  Indirect.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property wrapper that adds a layer of indirection to its `WrappedValue` when needed.
///
/// This is particularly useful when you have a struct type that wants to nest another value of itself.
///
/// - Note: This uses value semantics, if you want reference semantics see `@IndirectReference`.
@propertyWrapper
public struct Indirect<WrappedValue>: MutablePropertyWrapper, DefaultInitializablePropertyWrapper, ProjectedPropertyWrapper {
    /// The box type that enables `Indirect` to work.
    @usableFromInline
    indirect enum Box {
        case value(WrappedValue)
    }

    @usableFromInline
    var _box: Box?

    @_transparent
    @usableFromInline
    var box: Box {
        // This extra layer of indirection is needed to support _modify access to wrappedValue
        get { _box.unsafelyUnwrapped }
        set { _box = newValue }
    }

    @inlinable
    public var wrappedValue: WrappedValue {
        get {
            switch box {
            case let .value(value):
                return value
            }
        }
        set {
            box = .value(newValue)
        }
        _modify {
            // This accessor does some extra explicit memory management to help avoid COW overhead.
            // If you track the reference counts they should go to +1 then back down to +0 right away.
            // Of course the compiler can choose to place the memory management wherever it wants to so there still might be COW overhead in some cases...
            defer { _fixLifetime(self) }

            var wrappedValue: WrappedValue
            switch box {
            case let .value(value):
                wrappedValue = value
            }

            // Invalidate _box so it is not keeping a reference to the value we are going to yield in order to avoid COW
            _box = nil
            defer {
                _box = .value(wrappedValue)
            }
            yield &wrappedValue
        }
    }

    @inlinable
    public var projectedValue: Self { self }

    /// Creates an `@Indirect`.
    ///
    /// - Parameter wrappedValue: The initial value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self._box = .value(wrappedValue)
    }
}

extension Indirect: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension Indirect: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension Indirect: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
extension Indirect: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension Indirect: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
