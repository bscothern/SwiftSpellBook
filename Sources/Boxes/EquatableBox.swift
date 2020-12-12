//
//  EquatableBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@dynamicMemberLookup
public struct EquatableBox<Value>: MutableBox, Equatable {
    public typealias AreEqualFunction = (_ lhs: Value, _ rhs: Value) -> Bool

    public var boxedValue: Value

    @usableFromInline
    let areEqual: AreEqualFunction

    @inlinable
    public init(_ boxedValue: Value, areEqualBy areEqual: @escaping AreEqualFunction) {
        self.boxedValue = boxedValue
        self.areEqual = areEqual
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.areEqual(lhs.boxedValue, rhs.boxedValue)
    }

    public subscript<Result>(dynamicMember keyPath: KeyPath<Value, Result>) -> Result {
        boxedValue[keyPath: keyPath]
    }

    public subscript<Result>(dynamicMember keyPath: WritableKeyPath<Value, Result>) -> Result {
        get { boxedValue[keyPath: keyPath] }
        set { boxedValue[keyPath: keyPath] = newValue }
        _modify { yield &boxedValue[keyPath: keyPath] }
    }

    public subscript<Result>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Result>) -> Result {
        get { boxedValue[keyPath: keyPath] }
        set { boxedValue[keyPath: keyPath] = newValue }
        _modify { yield &boxedValue[keyPath: keyPath] }
    }
}
