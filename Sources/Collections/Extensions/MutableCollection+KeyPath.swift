//
//  MutableCollection+KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

extension MutableCollection where Self: RandomAccessCollection {
    @inlinable
    public mutating func sort<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) where ComparableValue: Comparable {
        sort(keyPath: keyPath, by: <)
    }

    @inlinable
    public mutating func sort<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>, by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool) {
        sort(by: { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) })
    }

    @inlinable
    public mutating func assign<Value>(_ keyPath: WritableKeyPath<Element, Value>, to newValue: Value) {
        var index = startIndex
        while index != endIndex {
            defer { formIndex(after: &index) }
            self[index][keyPath: keyPath] = newValue
        }
    }
}

#if swift(<5.2)
extension MutableCollection {
    @inlinable
    public mutating func partition(by keyPath: KeyPath<Element, Bool>) -> Index {
        partition(by: { $0[keyPath: keyPath] })
    }
}
#endif
