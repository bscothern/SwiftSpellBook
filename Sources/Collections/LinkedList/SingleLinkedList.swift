//
//  SingleLinkedList.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public struct SingleLinkedList<Element>: _LinkedListProtocol {
    @usableFromInline
    typealias Node = SingleLinkedListNode<Element>
    
    @usableFromInline
    var buffer: Buffer
    
    @inlinable
    public init() {
        buffer = .init()
    }
    
    public mutating func append(_ element: Element) {
        createCopyIfNeeded()
        defer { count += 1 }
        guard let tail = buffer.tail else {
            buffer.head = .allocate(capacity: 1)
            buffer.head.unsafelyUnwrapped.initialize(to: .init(element: element))
            buffer.tail = buffer.head
            return
        }
        tail.pointee.initializeNext(to: .init(element: element))
        buffer.tail = tail.pointee.next
    }
    
    public mutating func prepend(_ element: Element) {
        createCopyIfNeeded()
        defer { count += 1 }
        let newHead = UnsafeMutablePointer<Node>.allocate(capacity: 1)
        newHead.initialize(to: .init(element: element))
        newHead.pointee.next = buffer.head
        buffer.head = newHead
        if buffer.tail == nil {
            buffer.tail = newHead
        }
    }
}

extension SingleLinkedList: Collection {
    public struct Index: LinkedListIndex {
        @usableFromInline
        typealias Base = SingleLinkedList<Element>

        @usableFromInline
        let value: Value

        @usableFromInline
        init(_ value: Value) {
            self.value = value
        }
    }
}

extension SingleLinkedList: Equatable where Element: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.buffer === rhs.buffer {
            return true
        }
        guard lhs.count == rhs.count else {
            return false
        }
        for (lhsValue, rhsValue) in zip(lhs, rhs) {
            if lhsValue != rhsValue {
                return false
            }
        }
        return true
    }
}
