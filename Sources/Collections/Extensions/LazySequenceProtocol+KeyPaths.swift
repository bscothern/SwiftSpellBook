//
//  LazySequenceProtocol+KeyPaths.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

extension LazySequenceProtocol {
    @inlinable
    public func filter<EquatableValue>(_ keyPath: KeyPath<Element, EquatableValue>, equalTo value: EquatableValue) -> LazyFilterSequence<Self.Elements> where EquatableValue: Equatable {
        filter { $0[keyPath: keyPath] == value }
    }

    @inlinable
    public func filter<EquatableValue>(_ keyPath: KeyPath<Element, EquatableValue>, notEqualto value: EquatableValue) -> LazyFilterSequence<Self.Elements> where EquatableValue: Equatable {
        filter { $0[keyPath: keyPath] != value }
    }

    @inlinable
    public func filter<Value>(_ keyPath: KeyPath<Element, Value>, satisifies predicate: @escaping (Value) -> Bool) -> LazyFilterSequence<Self.Elements> {
        filter { predicate($0[keyPath: keyPath]) }
    }
}
