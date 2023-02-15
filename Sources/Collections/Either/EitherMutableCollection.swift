//
//  EitherCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

public typealias EitherMutableCollection<Left, Right> = EitherCollection<Left, Right> where Left: MutableCollection, Right: MutableCollection, Left.Element == Right.Element

extension EitherMutableCollection: MutableCollection {
    @inlinable
    public subscript(position: Index) -> Element {
        // swiftlint doesn't recognize _modify as an accessor
        // swiftlint:disable:next implicit_getter
        get { getElement(at: position) }
        _modify {
            // This accessor does some extra explicit memory management to help avoid COW overhead.
            // If you track the reference counts they should go to +1 then back down to +0 right away.
            // Of course the compiler can choose to place the memory management wherever it wants to so there still might be COW overhead in some cases...
            defer { _fixLifetime(self) }

            var left: UnsafeMutablePointer<Left>?
            var right: UnsafeMutablePointer<Right>?

            // The LOE says that this instance can only be accessed and mutated by one thing at a time so as long as it is restored at the end it should be fine.
            // In fact this is what Dave Abrahams had done in this thread: https://forums.swift.org/t/law-of-exclusivity-memory-safety-question/43374
            withUnsafeMutablePointer(to: &_value) { value in
                switch value.move() {
                case let .left(value):
                    left = .allocate(capacity: 1)
                    left?.initialize(to: value)
                case let .right(value):
                    right = .allocate(capacity: 1)
                    right?.initialize(to: value)
                case .none:
                    fatalError("EitherMutableCollection has memory corruption and cannot find a value")
                }
            }

            defer {
                withUnsafeMutablePointer(to: &_value) { value in
                    if left != nil {
                        value.initialize(to: .left(left.unsafelyUnwrapped.move()))
                        left.unsafelyUnwrapped.deallocate()
                    } else if right != nil {
                        value.initialize(to: .right(right.unsafelyUnwrapped.move()))
                        right.unsafelyUnwrapped.deallocate()
                    } else {
                        fatalError("EitherMutableCollection.\(#function) failed to re-initialize storage")
                    }
                }
            }

            // Since unsafelyUnwrapped is read-only we need to determine what we have, bind it, yield, and unbind it to avoid COW
            switch (left, right, position.value) {
            case let (.some, .none, .left(position)):
                var yieldableLeft = left.unsafelyUnwrapped.move()
                defer {
                    left.unsafelyUnwrapped.initialize(to: yieldableLeft)
                }
                yield &yieldableLeft[position]

            case let (.none, .some, .right(position)):
                var yieldableRight = right.unsafelyUnwrapped.move()
                defer {
                    right.unsafelyUnwrapped.initialize(to: yieldableRight)
                }
                yield &yieldableRight[position]

            case (.none, .none, _):
                fatalError("EitherMutableCollection.\(#function) unable to find value to mutate")
            default:
                fatalError("EitherMutableCollection.\(#function) used with other index type")
            }
        }
    }
}
