//
//  IndirectBox.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 5/19/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// A `Box` that keeps makes its `Value` indirect so it can be on the heap if needed.
///
/// This is useful when you have a struct type and what to nest another instance of the same type within itself since you can't normally do this.
///
/// Generally you shouldn't need to use this `Box` type directly and can instead use the `@Indirect` property wrapper.
///
/// - Note: This uses value semantics, if you want reference semantics see `IndirectReferenceBox`.
public struct IndirectBox<Value>: MutableBox {
    @usableFromInline
    indirect enum Indirect {
        case value(Value)

        @usableFromInline
        @_transparent
        var open: Value {
            switch self {
            case let .value(value):
                return value
            }
        }
    }

    @usableFromInline
    var indirect: Indirect

    @inlinable
    @_transparent
    public var boxedValue: Value {
        get { indirect.open }
        set { indirect = .value(newValue) }
        _modify {
            // This accessor does some extra explicit memory management to help avoid COW overhead.
            // If you track the reference counts they should go to +1 then back down to +0 right away.
            // Of course the compiler can choose to place the memory management wherever it wants to so there still might be COW overhead in some cases...
            defer { _fixLifetime(self) }

            // The LOE says that this instance can only be accessed and mutated by one thing at a time so as long as it is restored at the end it should be fine.
            // In fact this is what Dave Abrahams had done in this thread: https://forums.swift.org/t/law-of-exclusivity-memory-safety-question/43374
            var value: Value!
            withUnsafeMutablePointer(to: &indirect) { boxPointer in
                value = boxPointer.move().open
            }
            defer {
                withUnsafeMutablePointer(to: &indirect) { boxPointer in
                    boxPointer.initialize(to: .value(value))
                }
            }

            yield &value
        }
    }

    /// Creates an `IndirectBox`.
    ///
    /// - Parameter boxedValue: The initial value to put in the box.
    @inlinable
    @_transparent
    public init(_ boxedValue: Value) {
        indirect = .value(boxedValue)
    }
}
