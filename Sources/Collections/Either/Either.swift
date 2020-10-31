//
//  Either.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public struct Either<Left, Right> {
    @usableFromInline
    enum _Either {
        case left(Left)
        case right(Right)
    }

    @usableFromInline
    var _value: _Either?

    @_transparent
    @usableFromInline
    var value: _Either {
        // This extra layer of indirection is needed to support EitherMutableCollection.subscript._modify. See it for details.
        _value.unsafelyUnwrapped
    }

    @inlinable
    public var left: Left? {
        switch value {
        case let .left(value):
            return value
        default:
            return nil
        }
    }

    @inlinable
    public var right: Right? {
        switch value {
        case let .right(value):
            return value
        default:
            return nil
        }
    }

    @usableFromInline
    init(_ left: Left, or _: Right.Type) {
        _value = .left(left)
    }

    @usableFromInline
    init(_: Left.Type, or right: Right) {
        _value = .right(right)
    }

    public static func left(_ left: Left) -> Self {
        Self.left(left, or: Right.self)
    }

    public static func right(_ right: Right) -> Self {
        Self.right(right, or: Left.self)
    }

    public static func left(_ left: Left, or _: Right.Type) -> Self {
        Self(left, or: Right.self)
    }

    public static func right(_ right: Right, or _: Left.Type) -> Self {
        Self(Left.self, or: right)
    }
}

extension Either: Equatable where Left: Equatable, Right: Equatable {}
extension Either._Either: Equatable where Left: Equatable, Right: Equatable {}

extension Either: Hashable where Left: Hashable, Right: Hashable {}
extension Either._Either: Hashable where Left: Hashable, Right: Hashable {}

extension Either: Comparable where Left: Comparable, Right: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}
extension Either._Either: Comparable where Left: Comparable, Right: Comparable {}
