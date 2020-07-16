//
//  SingleLinkedListNode.swift
//  ThingsMissingFromSwift
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

/// The `LinkedListNode` type used by `SingleLinkedList`
@usableFromInline
struct SingleLinkedListNode<Element>: LinkedListNode {
    @usableFromInline
    var element: Element

    @usableFromInline
    var next: UnsafeMutablePointer<Self>?

    /// Creates a `SingleLinkedListNode`.
    ///
    /// - Important: `next` should be a unique pointer such that only this node will own it once passed into this function.
    ///
    /// - Parameters:
    ///   - element: The value contained in this node.
    ///   - next: A pointer to the next node.
    @usableFromInline
    init(element: Element, next: UnsafeMutablePointer<Self>? = nil) {
        self.element = element
        self.next = next
    }
}
