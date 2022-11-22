//
//  SingleLinkedListNode.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

/// The `LinkedListNode` type used by `SingleLinkedList`
@usableFromInline
struct SingleLinkedListNode<Element>: LinkedListNode {
    @usableFromInline
    var element: Element

    @usableFromInline
    var next: UnsafeMutablePointer<Self>?

    @usableFromInline
    init(element: Element) {
        self.init(element: element, next: nil)
    }

    /// Creates a `SingleLinkedListNode`.
    ///
    /// - Important: `next` should be a unique pointer such that only this node will own it once passed into this function.
    ///
    /// - Parameters:
    ///   - element: The value contained in this node.
    ///   - next: A pointer to the next node.
    @usableFromInline
    init(element: Element, next: UnsafeMutablePointer<Self>?) {
        self.element = element
        self.next = next
    }

    @usableFromInline
    func createCopy() -> (head: UnsafeMutablePointer<Self>, tail: UnsafeMutablePointer<Self>) {
        let head = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        head.initialize(to: .init(element: element))
        var tail = head

        var current = next
        while current != nil {
            defer { current = current.unsafelyUnwrapped.pointee.next }
            tail.pointee.next = .allocate(capacity: 1)
            tail.pointee.next.unsafelyUnwrapped.initialize(to: current.unsafelyUnwrapped.pointee)
            tail = tail.pointee.next.unsafelyUnwrapped
        }

        return (head, tail)
    }
}
