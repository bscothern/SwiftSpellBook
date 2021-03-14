//
//  DefaultedDictionary.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 3/7/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

public struct DefaultedDictionary<Key, Value> where Key: Hashable {
    @usableFromInline
    let _defaultValue: () -> Value

    @inlinable
    public var defaultValue: Value { _defaultValue() }

    @usableFromInline
    var base: [Key: Value]
}

// MARK: - Init
extension DefaultedDictionary {
    @inlinable
    public init(defaultValue: @autoclosure @escaping () -> Value) {
        _defaultValue = defaultValue
        base = [:]
    }

    @inlinable
    public init(defaultValue: @autoclosure @escaping () -> Value, minimumCapacity: Int) {
        _defaultValue = defaultValue
        base = .init(minimumCapacity: minimumCapacity)
    }

    @inlinable
    public init<S>(defaultValue: @autoclosure @escaping () -> Value, uniqueKeysWithValues keysAndValues: S) where S: Sequence, S.Element == (Key, Value) {
        _defaultValue = defaultValue
        base = .init(uniqueKeysWithValues: keysAndValues)
    }

    @inlinable
    public init<S>(defaultValue: @autoclosure @escaping () -> Value, _ keysAndValues: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows where S: Sequence, S.Element == (Key, Value) {
        _defaultValue = defaultValue
        base = try .init(keysAndValues, uniquingKeysWith: combine)
    }

    @inlinable
    public init<S>(defaultValue: @autoclosure @escaping () -> Value, grouping values: S, by keyForValue: (S.Element) throws -> Key) rethrows where Value == [S.Element], S: Sequence {
        _defaultValue = defaultValue
        base = try .init(grouping: values, by: keyForValue)
    }
}

// MARK: - Inspecting a Dictionary
extension DefaultedDictionary {
    @inlinable
    public var isEmpty: Bool { base.isEmpty }

    @inlinable
    public var count: Int { base.count }

    @inlinable
    public var capacity: Int { base.capacity }
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
        base.index(forKey: key).map(Index.init)
    }

    // MARK: Keys
    @inlinable
    public var keys: Keys { .init(base.keys) }

    public struct Keys: Equatable, Collection {
        public typealias Element = Key

        public struct Index: Comparable {
            @usableFromInline
            var base: Dictionary<Key, Value>.Keys.Index

            @usableFromInline
            init(_ base: Dictionary<Key, Value>.Keys.Index) {
                self.base = base
            }

            public static func < (lhs: Self, rhs: Self) -> Bool {
                lhs.base < rhs.base
            }
        }

        @usableFromInline
        var base: Dictionary<Key, Value>.Keys

        @usableFromInline
        init(_ base: Dictionary<Key, Value>.Keys) {
            self.base = base
        }

        @inlinable
        public var startIndex: Index { .init(base.startIndex) }

        @inlinable
        public var endIndex: Index { .init(base.endIndex) }

        @inlinable
        public func index(after i: Index) -> Index {
            .init(base.index(after: i.base))
        }

        @inlinable
        public subscript(position: Index) -> Element {
            base[position.base]
        }
    }

    // MARK: Values
    @inlinable
    public var values: Values { .init(base.values) }

    public struct Values: MutableCollection {
        public typealias Element = Value

        public struct Index: Comparable {
            @usableFromInline
            var base: Dictionary<Key, Value>.Values.Index

            @usableFromInline
            init(_ base: Dictionary<Key, Value>.Values.Index) {
                self.base = base
            }

            public static func < (lhs: Self, rhs: Self) -> Bool {
                lhs.base < rhs.base
            }
        }

        @usableFromInline
        var base: Dictionary<Key, Value>.Values

        @usableFromInline
        init(_ base: Dictionary<Key, Value>.Values) {
            self.base = base
        }

        @inlinable
        public var startIndex: Index { .init(base.startIndex) }

        @inlinable
        public var endIndex: Index { .init(base.endIndex) }

        @inlinable
        public func index(after i: Index) -> Index {
            .init(base.index(after: i.base))
        }

        @inlinable
        public subscript(position: Index) -> Element {
            get { base[position.base] }
            set { base[position.base] = newValue }
            _modify {
                defer { _fixLifetime(self) }
                yield &base[position.base]
            }
        }
    }

    @inlinable
    public var first: Element? { base.first }

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
    public mutating func update(_ value: Value, forKey key: Key) -> Value? {
        base.updateValue(value, forKey: key)
    }
}

// MARK: - Protocol Conformance
// MARK: Collection
extension DefaultedDictionary: Collection {
    public typealias Element = (key: Key, value: Value)

    public struct Index: Comparable {
        @usableFromInline
        let base: Dictionary<Key, Value>.Index

        @usableFromInline
        init(_ base: Dictionary<Key, Value>.Index) {
            self.base = base
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.base == rhs.base
        }

        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.base < rhs.base
        }
    }

    @inlinable
    public var startIndex: Index {
        .init(base.startIndex)
    }

    @inlinable
    public var endIndex: Index {
        .init(base.endIndex)
    }

    @inlinable
    public func index(after i: Index) -> Index {
        .init(base.index(after: i.base))
    }

    @inlinable
    public subscript(position: Index) -> Element {
        base[position.base]
    }
}
