//
//  Indirect.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import SwiftBoxesSpellBook

/// A property wrapper that adds a layer of indirection to its `WrappedValue` when needed.
///
/// This is particularly useful when you have a struct type that wants to nest another value of itself.
///
/// - Note: This uses value semantics, if you want reference semantics see `@IndirectReference`.
@propertyWrapper
public struct Indirect<WrappedValue>: MutablePropertyWrapper, DefaultInitializablePropertyWrapper, ProjectedPropertyWrapper {
    @usableFromInline
    var box: IndirectBox<WrappedValue>

    @inlinable
    public var wrappedValue: WrappedValue {
        get { box.boxedValue }
        set { box.boxedValue = newValue }
        _modify { yield &box.boxedValue }
    }

    @inlinable
    public var projectedValue: Self { self }

    @inlinable
    public init(wrappedValue: WrappedValue) {
        self.box = .init(wrappedValue)
    }
}

extension Indirect: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {}
extension Indirect: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {}
extension Indirect: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {}
extension Indirect: PassThroughEncodablePropertyWrapper where WrappedValue: Encodable {}
extension Indirect: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {}
