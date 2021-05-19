//
//  IndirectReferenceBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 5/19/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A `Box` that keeps makes its `Value` indirect so it can be on the heap if needed.
///
/// This is useful when you have a struct type and what to nest another instance of the same type within itself since you can't normally do this.
///
/// Generally you shouldn't need to use this `Box` type directly and can instead use the `@IndirectReference` property wrapper.
///
/// - Note: This uses reference semantics, if you want value semantics see `IndirectBox`.
public final class IndirectReferenceBox<Value>: MutableBox {
    public var boxedValue: Value

    /// Creates an `IndirectReferenceBox`.
    ///
    /// - Parameter boxedValue: The initial value to put in the box.
    @inlinable
    @inline(__always)
    public init(_ boxedValue: Value) {
        self.boxedValue = boxedValue
    }
}
