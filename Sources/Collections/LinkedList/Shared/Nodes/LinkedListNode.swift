//
//  LinkedListNode.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

/// The common components of all nodes in linked lists.
@usableFromInline
protocol LinkedListNode {
    /// The type of value contained in each node.
    ///
    /// - Important: This should coorespond to the `LinkedList`'s `Collection` conformance `Element` type.
    associatedtype Element
    /// The `Element` value contained by this node.
    var element: Element { get set }

    /// A pointer to the next node in the list.
    var next: UnsafeMutablePointer<Self>? { get set }

    /// Creates a `LinkedListNode`.
    ///
    /// - Parameters:
    ///   - element: The value contained in this node.
    init(element: Element)

    /// Creates a copy of the node which is the new `head` and the `tail` is the last node in the new copy.
    func createCopy() -> (head: UnsafeMutablePointer<Self>, tail: UnsafeMutablePointer<Self>)
}

extension LinkedListNode {
    /// Allocates and initializes `self.next` value of this `LinkedListNode` to be the `next` parameter supplied to this function.
    ///
    /// - Precondition: `self.next` must be `nil`.
    ///
    /// - Parameter next: The next node that should be pointed to.
    @usableFromInline
    mutating func initializeNext(to next: Self) {
        precondition(self.next == nil)
        self.next = .allocate(capacity: 1)
        self.next.unsafelyUnwrapped.initialize(to: next)
    }
}

extension LinkedListNode {
    /// Iterates over all `next` pointers and deinitializes and deallocates them.
    ///
    /// This is done in such a way that only one is ever deallocated and deinitialized at a time preventing stack overflows.
    @usableFromInline
    func destoryNodes() {
        var nextNode: UnsafeMutablePointer<Self>? = next
        while let current = nextNode {
            nextNode = current.pointee.next
            current.deinitialize(count: 1)
            current.deallocate()
        }
    }
}
