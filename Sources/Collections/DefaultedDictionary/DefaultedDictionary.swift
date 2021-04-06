//
//  DefaultedDictionary.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 3/7/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

import _AutoClosurePropertyWrapper

@dynamicMemberLookup
public struct DefaultedDictionary<Key, Value> where Key: Hashable {
    @AutoClosure
    public var defaultValue: Value

    @usableFromInline
    var base: [Key: Value]

    @inlinable
    public subscript <Result>(dynamicMember keyPath: KeyPath<[Key: Value], Result>) -> Result {
        _read { yield base[keyPath: keyPath] }
    }

    @inlinable
    public subscript <Result>(dynamicMember keyPath: WritableKeyPath<[Key: Value], Result>) -> Result {
        _read { yield base[keyPath: keyPath] }
        _modify {
            defer { _fixLifetime(self) }
            yield &base[keyPath: keyPath]
        }
    }
}

// MARK: - Init
extension DefaultedDictionary {
    @_transparent
    init(_defaultValue: AutoClosure<Value>, base: [Key: Value]) {
        self._defaultValue = _defaultValue
        self.base = base
    }

    @_transparent
    init(defaultValue: @escaping () -> Value, base: [Key: Value]) {
        self.init(
            _defaultValue: .init(wrappedValue: defaultValue),
            base: base
        )
    }

    public init(defaultValue: @autoclosure @escaping () -> Value) {
        self.init(
            defaultValue: defaultValue,
            base: [:]
        )
    }

    public init(defaultValue: @autoclosure @escaping () -> Value, minimumCapacity: Int) {
        self.init(
            defaultValue: defaultValue,
            base: .init(minimumCapacity: minimumCapacity)
        )
    }

    public init<S>(defaultValue: @autoclosure @escaping () -> Value, uniqueKeysWithValues keysAndValues: S) where S: Sequence, S.Element == (Key, Value) {
        self.init(
            defaultValue: defaultValue,
            base: .init(uniqueKeysWithValues: keysAndValues)
        )
    }

    public init<S>(defaultValue: @autoclosure @escaping () -> Value, _ keysAndValues: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows where S: Sequence, S.Element == (Key, Value) {
        self.init(
            defaultValue: defaultValue,
            base: try .init(keysAndValues, uniquingKeysWith: combine)
        )
    }

    public init<S>(defaultValue: @autoclosure @escaping () -> Value, grouping values: S, by keyForValue: (S.Element) throws -> Key) rethrows where Value == [S.Element], S: Sequence {
        self.init(
            defaultValue: defaultValue,
            base: try .init(grouping: values, by: keyForValue)
        )
    }
}

// MARK: - Accessing Keys and Values
extension DefaultedDictionary {
    @inlinable
    public subscript(key: Key) -> Value {
        base[key, default: defaultValue]
    }

    @inlinable
    public subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value {
        base[key, default: defaultValue()]
    }

    @inlinable
    public func index(forKey key: Key) -> Index? {
        base.index(forKey: key)
    }

    @inlinable
    public func randomElement() -> Element? {
        base.randomElement()
    }

    @inlinable
    public func randomElement<T>(using generator: inout T) -> Element? where T: RandomNumberGenerator {
        base.randomElement(using: &generator)
    }
}

// MARK: - Adding Keys and Values
extension DefaultedDictionary {
    // FIXME: Should this return an optional or the default value in this case?
    // If it returns `nil` then you know the value would have defaulted.
    @inlinable
    @discardableResult
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        base.updateValue(value, forKey: key)
    }

    @inlinable
    public mutating func merge(_ other: Self, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        try base.merge(other.base, uniquingKeysWith: combine)
    }

    @inlinable
    public mutating func merge(_ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        try base.merge(other, uniquingKeysWith: combine)
    }

    @inlinable
    public mutating func merge<S>(_ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows where S: Sequence, S.Element == (Key, Value) {
        try base.merge(other, uniquingKeysWith: combine)
    }

    public func merging(_ other: Self, uniquingKeysWith combine: (Value, Value) throws -> Value, usingDefault: (AutoClosure<Value>, AutoClosure<Value>) throws -> AutoClosure<Value> = { first, _ in first }) rethrows -> Self {
        var copy = base
        try copy.merge(other.base, uniquingKeysWith: combine)
        let defaultValue = try usingDefault($defaultValue, other.$defaultValue)
        return .init(
            _defaultValue: defaultValue,
            base: copy
        )
    }

    @inlinable
    public func merging(_ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> Self {
        var copy = self
        try copy.base.merge(other, uniquingKeysWith: combine)
        return copy
    }

    @inlinable
    @_disfavoredOverload
    public func merging<S>(_ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> Self where S: Sequence, S.Element == (Key, Value) {
        var copy = self
        try copy.base.merge(other, uniquingKeysWith: combine)
        return copy
    }
}

// MARK: - Protocol Conformance
// MARK: Collection
extension DefaultedDictionary: Collection {
    public typealias Element = (key: Key, value: Value)
    public typealias Index = Dictionary<Key, Value>.Index

    @inlinable
    public var startIndex: Index { base.startIndex }

    @inlinable
    public var endIndex: Index { base.endIndex }

    @inlinable
    public func index(after i: Index) -> Index {
        base.index(after: i)
    }

    @inlinable
    public subscript(position: Index) -> Element {
        base[position]
    }
}
