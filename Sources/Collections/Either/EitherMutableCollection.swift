//
//  EitherCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public typealias EitherMutableCollection<Left, Right> = EitherCollection<Left, Right> where Left: MutableCollection, Right: MutableCollection, Left.Element == Right.Element, Left: IsUnique, Right: IsUnique

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
        _modify {
            // This accessor does some extra explicit memory management to help avoid COW overhead.
            // If you track the reference counts they should go to +1 then back down to +0 right away.
            // Of course the compiler can choose to place the memory management wherever it wants to so there still might be COW overhead in some cases...
            defer { _fixLifetime(self) }

            var left: UnsafeMutablePointer<Left>?
            var right: UnsafeMutablePointer<Right>?
            
            withUnsafeMutablePointer(to: &_value) { value in
                switch value.pointee {
                case let .left(value):
                    left = .allocate(capacity: 1)
                    left?.initialize(to: value)
                case let .right(value):
                    right = .allocate(capacity: 1)
                    right?.initialize(to: value)
                case .none:
                    fatalError("EitherMutableCollection has memory corruption and cannot find a value")
                }
                value.deinitialize(count: 1)
            }
            
            guard !(left?.pointee.isUnique() ?? right?.pointee.isUnique() ?? true) else {
                fatalError("1")
            }

//            // Invalidate _value so it is not keeping a reference to the value we are going to yield in order to avoid COW
//            _value = nil

//            guard left?.isUnique() ?? right?.isUnique() ?? false else {
//                fatalError("3")
//            }
            
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

            guard left?.pointee.isUnique() ?? right?.pointee.isUnique() ?? false else {
                fatalError("2")
            }

            // Since unsafelyUnwrapped is read-only we need to determine what we have, bind it, yield, and unbind it to avoid COW
            switch (left, right, position.value) {
            case let (.some, .none, .left(position)):
                var yieldableLeft = left.unsafelyUnwrapped.pointee
                left.unsafelyUnwrapped.deinitialize(count: 1)
                
                guard yieldableLeft.isUnique() else {
                    fatalError("3")
                }
                
                defer {
                    left.unsafelyUnwrapped.initialize(to: yieldableLeft)
                }
                
                guard yieldableLeft.isUnique() else {
                    fatalError("4")
                }
                yield &yieldableLeft[position]
            case let (.none, .some, .right(position)):
                var yieldableRight = right.unsafelyUnwrapped.pointee
                right.unsafelyUnwrapped.deinitialize(count: 1)
                
                guard yieldableRight.isUnique() else {
                    fatalError("3")
                }
                
                defer {
                    right.unsafelyUnwrapped.initialize(to: yieldableRight)
                }
                
                guard yieldableRight.isUnique() else {
                    fatalError("4")
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

public protocol IsUnique {
    mutating func isUnique() -> Bool
}
