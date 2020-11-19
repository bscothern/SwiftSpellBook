//
//  Sequence+KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

extension Sequence {
    @inlinable
    public func min<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) -> Element? where ComparableValue: Comparable {
        min(keyPath: keyPath, by: <)
    }

    @inlinable
    public func min<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>, by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool) -> Element? {
        self.min(by: { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) })
    }

    @inlinable
    public func max<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) -> Element? where ComparableValue: Comparable {
        max(keyPath: keyPath, by: >)
    }

    @inlinable
    public func max<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>, by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool) -> Element? {
        self.max(by: { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) })
    }

    @inlinable
    public func sorted<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) -> [Element] where ComparableValue: Comparable {
        sorted(keyPath: keyPath, by: <)
    }

    @inlinable
    public func sorted<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>, by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool) -> [Element] {
        sorted(by: { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) })
    }
}

#if swift(<5.2)
extension Sequence {
    @inlinable
    public func map<Value>(_ keyPath: KeyPath<Element, Value>) -> [Value] {
        map { $0[keyPath: keyPath] }
    }

    @inlinable
    public func flatMap<Value>(_ keyPath: KeyPath<Element, [Value]>) -> [Value] {
        flatMap { $0[keyPath: keyPath] }
    }

    @inlinable
    public func compactMap<Value>(_ keyPath: KeyPath<Element, Value?>) -> [Value] {
        compactMap { $0[keyPath: keyPath] }
    }

    @inlinable
    public func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        filter { $0[keyPath: keyPath] }
    }

    @inlinable
    public func contains(where keyPath: KeyPath<Element, Bool>) -> Bool {
        contains(where: { $0[keyPath: keyPath] })
    }

    @inlinable
    public func first(where keyPath: KeyPath<Element, Bool>) -> Element? {
        first(where: { $0[keyPath: keyPath] })
    }

    @inlinable
    public func allSatisfy(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        allSatisfy { $0[keyPath: keyPath] }
    }

    @inlinable
    public func drop(while keyPath: KeyPath<Element, Bool>) -> DropWhileSequence<Self> {
        drop(while: { $0[keyPath: keyPath] })
    }

    @inlinable
    public func prefix(while keyPath: KeyPath<Element, Bool>) -> [Element] {
        prefix(while: { $0[keyPath: keyPath] })
    }
}
#endif
