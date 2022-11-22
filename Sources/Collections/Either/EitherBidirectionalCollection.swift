//
//  EitherBidirectionalCollection.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

public typealias EitherBidirectionalCollection<Left, Right> = EitherCollection<Left, Right> where Left: BidirectionalCollection, Right: BidirectionalCollection, Left.Element == Right.Element

extension EitherBidirectionalCollection: BidirectionalCollection {
    @inlinable
    public func index(before i: Index) -> Index {
        switch (value, i.value) {
        case let (.left(value), .left(i)):
            return .left(value.index(before: i))
        case let (.right(value), .right(i)):
            return .right(value.index(before: i))
        default:
            fatalError("EitherBidirectionalCollection.\(#function) used with other index type")
        }
    }
}
