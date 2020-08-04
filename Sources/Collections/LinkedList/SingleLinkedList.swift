//
//  SingleLinkedList.swift
//  ThingsMissingFromSwift
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
    
    @inlinable
    public mutating func popLast() -> Element? {
        createCopyIfNeeded()
        return buffer.popLast()
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
    
    @inlinable
    public var startIndex: Index { .init(buffer.startIndex) }
    
    @inlinable
    public var endIndex: Index { .init(buffer.endIndex) }
    
    @inlinable
    public var count: Int {
        get { buffer.count }
        set { buffer.count = newValue }
        _modify { yield &buffer.count }
    }
    
    @inlinable
    public func index(after i: Index) -> Index {
        .init(buffer.index(after: i.value))
    }
    
    @inlinable
    public subscript(position: Index) -> Element {
        buffer[position.value]
    }
    
//    @inlinable
//    public subscript(bounds: Range<Index>) -> Slice<Self> {
//        Slice(base: self, bounds: bounds)
//    }
}
