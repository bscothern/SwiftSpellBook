//
//  EitherCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public typealias EitherCollection<Left, Right> = EitherSequence<Left, Right> where Left: Collection, Right: Collection, Left.Element == Right.Element

extension EitherCollection: Collection {
    public typealias Index = Either<Left.Index, Right.Index>

    @inlinable
    public var startIndex: Index {
        switch value {
        case let .left(value):
            return .left(value.startIndex)
        case let .right(value):
            return .right(value.startIndex)
        }
    }

    @inlinable
    public var endIndex: Index {
        switch value {
        case let .left(value):
            return .left(value.endIndex)
        case let .right(value):
            return .right(value.endIndex)
        }
    }

    @inlinable
    public subscript(position: Either<Left.Index, Right.Index>) -> Element {
        switch (value, position.value) {
        case let (.left(value), .left(position)):
            return value[position]
        case let (.right(value), .right(position)):
            return value[position]
        default:
            fatalError("EitherCollection.\(#function) used with other index type")
        }
    }

    @inlinable
    public func index(after i: Either<Left.Index, Right.Index>) -> Index {
        switch (value, i.value) {
        case let (.left(value), .left(i)):
            return .left(value.index(after: i))
        case let (.right(value), .right(i)):
            return .right(value.index(after: i))
        default:
            fatalError("EitherCollection:\(#function) used with other index type")
        }
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        switch (value, i.value) {
        case let (.left(value), .left(i)):
            return .left(value.index(i, offsetBy: distance))
        case let (.right(value), .right(i)):
            return .right(value.index(i, offsetBy: distance))
        default:
            fatalError("EitherCollection:\(#function) used with other index type")
        }
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        switch (value, i.value, limit.value) {
        case let (.left(value), .left(i), .left(limit)):
            return value.index(i, offsetBy: distance, limitedBy: limit).map(Index.left)
        case let (.right(value), .right(i), .right(limit)):
            return value.index(i, offsetBy: distance, limitedBy: limit).map(Index.right)
        default:
            fatalError("EitherCollection:\(#function) used with other index type")
        }
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        switch (value, start.value, end.value) {
        case let (.left(value), .left(start), .left(end)):
            return value.distance(from: start, to: end)
        case let (.right(value), .right(start), .right(end)):
            return value.distance(from: start, to: end)
        default:
            fatalError("EitherCollection:\(#function) used with other index type")
        }
    }
}
