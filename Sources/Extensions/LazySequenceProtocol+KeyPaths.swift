//
//  LazySequenceProtocol+KeyPaths.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/18/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if swift(<5.2)
extension LazySequenceProtocol {
    @inlinable
    public func map<Value>(_ keyPath: KeyPath<Element, Value>) -> LazyMapSequence<Self.Elements, Value> {
        map { $0[keyPath: keyPath] }
    }

    @inlinable
    func flatMap<Value>(_ keyPath: KeyPath<Self.Elements.Element, Value>) -> LazySequence<FlattenSequence<LazyMapSequence<Self.Elements, Value>>> where Value: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }

    @inlinable
    public func compactMap<Value>(_ keyPath: KeyPath<Self.Elements.Element, Value?>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Self.Elements, Value?>>, Value> {
        compactMap { $0[keyPath: keyPath] }
    }

    @inlinable
    public func filter(_ keyPath: KeyPath<Element, Bool>) -> LazyFilterSequence<Self.Elements> {
        filter { $0[keyPath: keyPath] }
    }

    @inlinable
    public func drop(while keyPath: KeyPath<Element, Bool>) -> LazyDropWhileSequence<Self.Elements> {
        drop(while: { $0[keyPath: keyPath] })
    }

    @inlinable
    public func prefix(while keyPath: KeyPath<Element, Bool>) -> LazyPrefixWhileSequence<Self.Elements> {
        prefix(while: { $0[keyPath: keyPath] })
    }
}
#endif
