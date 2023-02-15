//
//  MutableCollection+KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

extension MutableCollection where Self: RandomAccessCollection {
    @inlinable
    @_transparent
    public mutating func sort<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>)
    where ComparableValue: Comparable {
        sort(keyPath: keyPath, by: <)
    }

    @inlinable
    public mutating func sort<ComparableValue>(
        keyPath: KeyPath<Element, ComparableValue>,
        by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool
    ) {
        sort { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    @inlinable
    public mutating func assign<Value>(
        _ value: Value,
        to keyPath: WritableKeyPath<Element, Value>
    ) {
        var index = startIndex
        while index != endIndex {
            defer { formIndex(after: &index) }
            self[index][keyPath: keyPath] = value
        }
    }
}
