//
//  Indirect.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property wrapper that adds a layer of indirection to its WrappedValue when needed.
///
/// This is particularly useful when you have a struct type that wants to nest another value of itself.
@propertyWrapper
public struct Indirect<WrappedValue> {
    @usableFromInline
    indirect enum _Indirect {
        case value(WrappedValue)
    }

    @usableFromInline
    var value: _Indirect

    @inlinable
    public var wrappedValue: WrappedValue {
        switch value {
        case let .value(value):
            return value
        }
    }

    @inlinable
    public var projectedValue: Self { self }

    /// Creates an `@Indirect`.
    ///
    /// - Parameter wrappedValue: The initial value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.value = .value(wrappedValue)
    }
}

extension Indirect: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension Indirect: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension Indirect: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
extension Indirect: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension Indirect: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
