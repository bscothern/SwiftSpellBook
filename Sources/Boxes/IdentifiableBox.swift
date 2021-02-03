//
//  IdentifiableBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@dynamicMemberLookup
public struct IdentifiableBox<Value, ID>: MutableBox, Identifiable where ID: Hashable {
    public var boxedValue: Value

    @inlinable
    public var id: ID { idGenerator(boxedValue) }

    @usableFromInline
    let idGenerator: (Value) -> ID

    @inlinable
    public init(_ boxedValue: Value, id: @escaping @autoclosure () -> ID) {
        self.init(boxedValue) { _ in id() }
    }

    @inlinable
    public init(_ boxedValue: Value, idBy idGenerator: @escaping (Value) -> ID) {
        self.boxedValue = boxedValue
        self.idGenerator = idGenerator
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
