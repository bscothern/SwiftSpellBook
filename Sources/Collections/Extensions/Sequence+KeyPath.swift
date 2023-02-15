//
//  Sequence+KeyPath.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

extension Sequence {
    @inlinable
    public func assign<Value>(
        _ value: Value,
        to keyPath: ReferenceWritableKeyPath<Element, Value>
    ) {
        forEach {
            $0[keyPath: keyPath] = value
        }
    }

    @inlinable
    public func reduce<Result, Value>(
        _ keyPath: KeyPath<Element, Value>,
        initialValue: Result,
        _ nextPartialResult: (Result, Value) -> Result
    ) -> Result {
        reduce(initialValue) { result, element in
            nextPartialResult(result, element[keyPath: keyPath])
        }
    }

    @inlinable
    public func reduce<Result, Value>(
        _ keyPath: KeyPath<Element, Value>,
        into initialValue: Result,
        _ nextPartialResult: (inout Result, Value) -> Void
    ) -> Result {
        reduce(into: initialValue) { result, element in
            nextPartialResult(&result, element[keyPath: keyPath])
        }
    }
}

extension Sequence {
    @inlinable
    public func min<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) -> Element?
    where ComparableValue: Comparable {
        min(keyPath: keyPath, by: <)
    }

    @inlinable
    public func min<ComparableValue>(
        keyPath: KeyPath<Element, ComparableValue>,
        by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool
    ) -> Element? {
        // swiftformat:disable:next redundantSelf
        self.min { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    @inlinable
    public func max<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) -> Element?
    where ComparableValue: Comparable {
        max(keyPath: keyPath, by: >)
    }

    @inlinable
    public func max<ComparableValue>(
        keyPath: KeyPath<Element, ComparableValue>,
        by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool
    ) -> Element? {
        // swiftformat:disable:next redundantSelf
        self.max { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    @inlinable
    public func sorted<ComparableValue>(keyPath: KeyPath<Element, ComparableValue>) -> [Element]
    where ComparableValue: Comparable {
        sorted(keyPath: keyPath, by: <)
    }

    @inlinable
    public func sorted<ComparableValue>(
        keyPath: KeyPath<Element, ComparableValue>,
        by areInIncreasingOrder: (ComparableValue, ComparableValue) -> Bool
    ) -> [Element] {
        sorted { areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    @inlinable
    public func filter<EquatableValue>(
        _ keyPath: KeyPath<Element, EquatableValue>,
        equalTo value: EquatableValue
    ) -> [Element]
    where EquatableValue: Equatable {
        filter { $0[keyPath: keyPath] == value }
    }

    @inlinable
    public func filter<EquatableValue>(
        _ keyPath: KeyPath<Element, EquatableValue>,
        notEqualto value: EquatableValue
    ) -> [Element]
    where EquatableValue: Equatable {
        filter { $0[keyPath: keyPath] != value }
    }

    @inlinable
    public func filter<Value>(
        _ keyPath: KeyPath<Element, Value>,
        satisifies predicate: (Value) -> Bool
    ) -> [Element] {
        filter { predicate($0[keyPath: keyPath]) }
    }
}
