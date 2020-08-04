//
//  LinkedListIndex.swift
//  ThingsMissingFromSwift
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

@usableFromInline
protocol LinkedListIndex: Comparable, ExpressibleByIntegerLiteral, ExpressibleByNilLiteral {
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
        self.init(.init(node: nil, offset: .value(value)))
    }
}

extension LinkedListIndex {
    @inlinable
    public init(nilLiteral: ()) {
        self.init(.init(node: nil, offset: .end))
    }
}
