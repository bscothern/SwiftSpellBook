//
//  LinkedListIndex.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
protocol LinkedListIndex: Comparable, ExpressibleByIntegerLiteral {
    associatedtype Base: _LinkedListProtocol
    typealias Value = Base.Buffer.Index

    var value: Value { get }

    init(_ value: Value)
}

extension LinkedListIndex {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

extension LinkedListIndex {
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(.init(node: nil, offset: value))
    }
}
