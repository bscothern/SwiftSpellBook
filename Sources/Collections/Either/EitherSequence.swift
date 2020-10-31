//
//  EitherSequence.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public typealias EitherSequence<Left, Right> = Either<Left, Right> where Left: Sequence, Right: Sequence, Left.Element == Right.Element
extension EitherSequence {
    public typealias Element = Left.Element
}

extension EitherSequence: Sequence {
    public struct Iterator: IteratorProtocol {
        public typealias Element = EitherSequence.Element

        @usableFromInline
        var left: Left.Iterator?

        @usableFromInline
        var right: Right.Iterator?

        @usableFromInline
        init(left: Left.Iterator) {
            self.left = left
            self.right = nil
        }

        @usableFromInline
        init(right: Right.Iterator) {
            self.left = nil
            self.right = right
        }

        @inlinable
        mutating public func next() -> Element? {
            left?.next() ?? right?.next()
        }
    }

    @inlinable
    public func makeIterator() -> Iterator {
        switch value {
        case let .left(value):
            return .init(left: value.makeIterator())
        case let .right(value):
            return .init(right: value.makeIterator())
        }
    }
}
