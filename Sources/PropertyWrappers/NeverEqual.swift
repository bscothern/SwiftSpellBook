//
//  NeverEqual.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A property wrapper that always treats the underlying value as never equal.
@propertyWrapper
public struct NeverEqual<WrappedValue>: MutablePropertyWrapper, DefaultInitializablePropertyWrapper, ProjectedPropertyWrapper, Equatable {
    public var wrappedValue: WrappedValue

    @inlinable
    public var projectedValue: Self { self }

    /// Creates a `NeverEqual`.
    ///
    /// - Parameter wrappedValue: The initial value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        false
    }
}

extension NeverEqual: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension NeverEqual: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
