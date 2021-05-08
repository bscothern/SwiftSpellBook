//
//  DefaultedDictionary.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 3/7/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

@propertyWrapper
public struct AutoClosure<WrappedValue>: PropertyWrapper, ProjectedPropertyWrapper {
    @usableFromInline
    let _wrappedValue: () -> WrappedValue

    @inlinable
    @_transparent
    public var wrappedValue: WrappedValue { _wrappedValue() }

    @inlinable
    public var projectedValue: Self { self }

    @inlinable
    public init(wrappedValue: @escaping () -> WrappedValue) {
        self._wrappedValue = wrappedValue
    }

    @inlinable
    public init(wrappedValue: @escaping @autoclosure () -> WrappedValue) {
        self._wrappedValue = wrappedValue
    }
}
