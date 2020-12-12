//
//  CustomHashable.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/1/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import SwiftBoxesSpellBook

@propertyWrapper
public struct CustomHashable<WrappedValue>: MutablePropertyWrapper, Hashable {
    @inlinable
    public var wrappedValue: WrappedValue {
        get { box.boxedValue }
        set { box.boxedValue = newValue }
        _modify { yield &box.boxedValue }
    }

    @usableFromInline
    var box: HashableBox<WrappedValue>

    @inlinable
    public init(wrappedValue: WrappedValue, areEqualBy areEqual: @escaping (WrappedValue, WrappedValue) -> Bool, hashedBy hashFunction: @escaping (_ hasher: inout Hasher, _ value: WrappedValue) -> Void) {
        self.box = .init(wrappedValue, areEqualBy: areEqual, hashedBy: hashFunction)
    }

    @inlinable
    public init(wrappedValue: WrappedValue, hashedBy hashFunction: @escaping (_ hasher: inout Hasher, _ value: WrappedValue) -> Void) where WrappedValue: Equatable {
        self.init(wrappedValue: wrappedValue, areEqualBy: ==, hashedBy: hashFunction)
    }
}
