//
//  IdentifiableBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A `Box` that a custom implimentation that allows a custom implimentation `Identifiable` for the contained type.
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
@dynamicMemberLookup
public struct IdentifiableBox<Value, ID>: MutableBox, Identifiable where ID: Hashable {
    /// A function that maps the `Value` of the `Box` to its `ID`.
    public typealias IDGenerator = (Value) -> ID
    
    public var boxedValue: Value

    @inlinable
    public var id: ID { idGenerator(boxedValue) }

    @usableFromInline
    let idGenerator: IDGenerator

    /// Creates an `IdentifiableBox`.
    ///
    /// - Parameters:
    ///   - boxedValue: The inital value of the `Box`.
    ///   - id: The `IDGenerator` to use create the `ID` of the `boxedValue`.
    @inlinable
    public init(
        _ boxedValue: Value,
        idBy idGenerator: @escaping IDGenerator
    ) {
        self.boxedValue = boxedValue
        self.idGenerator = idGenerator
    }
    
    /// Creates an `IdentifiableBox`.
    ///
    /// - Parameters:
    ///   - boxedValue: The inital value of the `Box`.
    ///   - id: The `ID` to always use regardless of the boxed value.
    @inlinable
    public init(
        _ boxedValue: Value,
        id: @escaping @autoclosure () -> ID
    ) {
        self.init(boxedValue) { _ in id() }
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
        nonmutating set { boxedValue[keyPath: keyPath] = newValue }
        nonmutating _modify { yield &boxedValue[keyPath: keyPath] }
    }
}
