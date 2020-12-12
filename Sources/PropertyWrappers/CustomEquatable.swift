//
//  CustomEquatable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import SwiftBoxesSpellBook

@propertyWrapper
public struct CustomEquatable<WrappedValue>: MutablePropertyWrapper, Equatable {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { box.boxedValue }
        set { box.boxedValue = newValue }
        _modify { yield &box.boxedValue }
    }

    @usableFromInline
    var box: EquatableBox<WrappedValue>

    @inlinable
    public init(wrappedValue: WrappedValue, areEqualBy areEqual: @escaping (WrappedValue, WrappedValue) -> Bool) {
        box = .init(wrappedValue, areEqualBy: areEqual)
    }
}
