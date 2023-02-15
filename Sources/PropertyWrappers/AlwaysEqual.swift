//
//  AlwaysEqual.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// A property wrapper that always treats the underlying value as equal.
@propertyWrapper
public struct AlwaysEqual<WrappedValue>: MutablePropertyWrapper, DefaultInitializablePropertyWrapper, ProjectedPropertyWrapper, Equatable {
    public var wrappedValue: WrappedValue

    @inlinable
    public var projectedValue: Self { self }

    /// Creates a `@AlwaysEqual`.
    ///
    /// - Parameter wrappedValue: The initial value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension AlwaysEqual: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension AlwaysEqual: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
