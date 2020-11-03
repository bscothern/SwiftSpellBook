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
        case let .value(value, _):
            return value
        }
    }

    @inlinable
    public var projectedValue: Self { self }

    /// Creates an `@Indirect`.
    ///
    /// - Parameter wrappedValue: The initail value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.value = .value(wrappedValue)
    }
}

extension Indirect: Equatable where WrappedValue: Equatable {}
extension Indirect._Indirect: Equatable where WrappedValue: Equatable {}
extension Indirect: Hashable where WrappedValue: Hashable {}
extension Indirect._Indirect: Hashable where WrappedValue: Hashable {}

extension Indirect where WrappedValue: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension Indirect where WrappedValue: Decodable {
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(WrappedValue.self)
        self = .init(wrappedValue: value)
    }
}
