//
//  AlwaysEqual.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// A property wrapper that always treats the underlyting value as equal.
@propertyWrapper
public struct AlwaysEqual<WrappedValue>: Equatable {
    public var wrappedValue: WrappedValue

    @inlinable
    public var projectedValue: Self { self }

    /// Creates a `@AlwaysEqual`.
    ///
    /// - Parameter wrappedValue: The initail value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension AlwaysEqual where WrappedValue: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension AlwaysEqual where WrappedValue: Decodable {
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(WrappedValue.self)
        self = .init(wrappedValue: value)
    }
}