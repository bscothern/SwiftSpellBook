//
//  DoubleLinkedList.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

public struct DoubleLinkedList<Element>: _LinkedListProtocol {
    @usableFromInline
    typealias Node = DoubleLinkedListNode<Element>

    @usableFromInline
    var buffer: Buffer

    @inlinable
    public init() {
        buffer = .init()
    }

    @inlinable
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

    @inlinable
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
    public mutating func insert(_ element: Element, at index: Index) {
        precondition(startIndex...endIndex ~= index, "Invalid index used to try and insert an element into list.")
        guard startIndex != index else {
            prepend(element)
            return
        }
        guard endIndex != index else {
            append(element)
            return
        }
        createCopyIfNeeded()
        defer { count += 1 }
        let (indexBefore, thisIndex) = findIndex(before: index)
        let newNode = UnsafeMutablePointer<Node>.allocate(capacity: 1)
        newNode.initialize(to: .init(element: element, next: thisIndex.value.node, previous: indexBefore.value.node))
        indexBefore.value.node?.pointee.next = newNode
        thisIndex.value.node?.pointee.previous = newNode
    }

    @inlinable
    public mutating func remove(at index: Index) {
        precondition(startIndex..<endIndex ~= index, "Invalid index used to try and remove from list.")
        createCopyIfNeeded()
        defer { count -= 1 }
        let (indexBefore, thisIndex) = findIndex(before: index)
        indexBefore.value.node.unsafelyUnwrapped.pointee.next = thisIndex.value.node
        thisIndex.value.node.unsafelyUnwrapped.deinitialize(count: 1)
        thisIndex.value.node.unsafelyUnwrapped.deallocate()
    }

    @usableFromInline
    func findIndex(before index: Index) -> (before: Index, index: Index) {
        var currentIndex = startIndex
        var nextIndex = self.index(after: currentIndex)
        while nextIndex != index {
            currentIndex = nextIndex
            nextIndex = self.index(after: currentIndex)
        }
        return (currentIndex, nextIndex)
    }
}

extension DoubleLinkedList: Collection {
    public struct Index: LinkedListIndex {
        @usableFromInline
        typealias Base = DoubleLinkedList<Element>

        @usableFromInline
        let value: Value

        @usableFromInline
        init(_ value: Value) {
            self.value = value
        }
    }
}

extension DoubleLinkedList: Equatable where Element: Equatable {}
extension DoubleLinkedList: Hashable where Element: Hashable {}
