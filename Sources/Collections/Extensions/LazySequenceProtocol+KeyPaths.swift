//
//  LazySequenceProtocol+KeyPathsTests.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

extension LazySequenceProtocol {
    @inlinable
    public func filter<EquatableValue>(
        _ keyPath: KeyPath<Element, EquatableValue>,
        equalTo value: @escaping @autoclosure () -> EquatableValue
    ) -> LazyFilterSequence<Self.Elements>
    where EquatableValue: Equatable {
        var _lazyValue: EquatableValue?
        var lazyValue: EquatableValue {
            guard let lazyValue = _lazyValue else {
                _lazyValue = value()
                return _lazyValue!
            }
            return lazyValue
        }
        return filter { $0[keyPath: keyPath] == lazyValue }
    }

    @inlinable
    public func filter<EquatableValue>(
        _ keyPath: KeyPath<Element, EquatableValue>,
        notEqualTo value: @escaping @autoclosure () -> EquatableValue
    ) -> LazyFilterSequence<Self.Elements>
    where EquatableValue: Equatable {
        var _lazyValue: EquatableValue?
        var lazyValue: EquatableValue {
            guard let lazyValue = _lazyValue else {
                _lazyValue = value()
                return _lazyValue!
            }
            return lazyValue
        }
        return filter { $0[keyPath: keyPath] != lazyValue }
    }

    @inlinable
    public func filter<Value>(
        _ keyPath: KeyPath<Element, Value>,
        satisifies predicate: @escaping (Value) -> Bool
    ) -> LazyFilterSequence<Self.Elements> {
        filter { predicate($0[keyPath: keyPath]) }
    }
}
