//
//  EitherCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public typealias EitherMutableCollection<Left, Right> = EitherCollection<Left, Right> where Left: MutableCollection, Right: MutableCollection, Left.Element == Right.Element

extension EitherMutableCollection: MutableCollection {
    @inlinable
    public subscript(position: Index) -> Element {
        // swiftlint doesn't recognize _modify as an accessor
        //swiftlint:disable:next implicit_getter
        get {
            switch (value, position.value) {
            case let (.left(value), .left(position)):
                return value[position]
            case let (.right(value), .right(position)):
                return value[position]
            default:
                fatalError("EitherMutableCollection.\(#function) used with other index type")
            }
        }
        mutating _modify {
            // This accessor does some extra explicit memory management to help avoid COW overhead.
            // If you track the reference counts they should go to +1 then back down to +0 right away.
            // Of course the compiler can choose to place the memory management wherever it wants to so there still might be COW overhead in some cases...

            var left: Left?
            var right: Right?

            switch value {
            case let .left(value):
                left = value
            case let .right(value):
                right = value
            }

            // Invalidate _value so it is not keeping a reference to the value we are going to yield in order to avoid COW
            _value = nil
            defer {
                if left != nil {
                    _value = .left(left.unsafelyUnwrapped)
                } else if right != nil {
                    _value = .right(right.unsafelyUnwrapped)
                } else {
                    fatalError("EitherMutableCollection.\(#function) failed to re-initialize storage")
                }
            }

            // Since unsafelyUnwrapped is read-only we need to determine what we have, bind it, yield, and unbind it to avoid COW
            switch (left, right, position.value) {
            case let (.some, .none, .left(position)):
                var yieldableLeft = left.unsafelyUnwrapped
                left = nil
                defer { left = yieldableLeft }
                yield &yieldableLeft[position]
            case let (.none, .some, .right(position)):
                var yieldableRight = right.unsafelyUnwrapped
                right = nil
                defer { right = yieldableRight }
                yield &yieldableRight[position]
            case (.none, .none, _):
                fatalError("EitherMutableCollection.\(#function) unable to find value to mutate")
            default:
                fatalError("EitherMutableCollection.\(#function) used with other index type")
            }
        }
    }
}
