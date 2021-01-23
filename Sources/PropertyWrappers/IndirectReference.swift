//
//  IndirectReference.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/5/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A property wrapper that adds a layer of indirection to its `WrappedValue` when needed.
///
/// This is particularly useful when you have a struct type that wants to nest another value of itself.
///
/// - Note: This uses reference semantics, if you want value semantics see `@Indirect`.
@propertyWrapper
public final class IndirectReference<WrappedValue>: MutablePropertyWrapper, DefaultInitializablePropertyWrapper, ProjectedPropertyWrapper {
    public var wrappedValue: WrappedValue

    @inlinable
    public var projectedValue: IndirectReference<WrappedValue> { self }

    /// Creates an `@IndirectReference`.
    ///
    /// - Parameter wrappedValue: The initial value of `wrappedValue`.
    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }
}

extension IndirectReference: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension IndirectReference: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension IndirectReference: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
extension IndirectReference: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension IndirectReference: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
