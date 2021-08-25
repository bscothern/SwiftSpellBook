//
//  DoubleLinkedListNode.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

/// This is a hack around a compiler warning regression introduced in 5.3.
///
/// The compiler warning this works around is this:
/// ```
/// Redundant conformance constraint 'Node': 'LinkedListNode'
/// ```
/// which occurs when using any form of this:
/// ```
/// extension LinkedListBuffer where Node == DoubleLinkedListNode<Element>
/// ```
@usableFromInline
protocol _DoubleLinkedListNode: LinkedListNode {
    var previous: UnsafeMutablePointer<Self>? { get }
}

/// The `LinkedListNode` type used by `DoubleLinkedList`
@usableFromInline
struct DoubleLinkedListNode<Element>: _DoubleLinkedListNode {
    @usableFromInline
    var element: Element

    @usableFromInline
    var next: UnsafeMutablePointer<Self>?

    /// A pointer to the previous node in the list.
    @usableFromInline
    var previous: UnsafeMutablePointer<Self>?

    @usableFromInline
    init(element: Element) {
        self.init(element: element, next: nil, previous: nil)
    }

    /// Creates a `SingleLinkedListNode`.
    ///
    /// - Important: `next` should be a unique pointer such that only this node will own it once passed into this function.
    ///
    /// - Important: `previous` should be a unique pointer such that only this node will own it once passed into this function.
    ///     This `previous` value should have the returned instance from this function set as its `next` after this call.
    ///
    /// - Parameters:
    ///   - element: The value contained in this node.
    ///   - next: A pointer to the next node.
    ///   - previous: A pointer to the previous node.
    @usableFromInline
    init(element: Element, next: UnsafeMutablePointer<Self>?, previous: UnsafeMutablePointer<Self>?) {
        self.element = element
        self.next = next
        self.previous = previous
    }

    /// Allocates and initializes `self.previous` value of this `LinkedListNode` to be the `previous` parameter supplied to this function.
    ///
    /// - Precondition: `self.previous` must be `nil`.
    ///
    /// - Parameter previous: The previous node that should be pointed to.
    @usableFromInline
    mutating func initializePrevious(to previous: Self) {
        precondition(self.previous == nil)
        self.previous = .allocate(capacity: 1)
        self.previous.unsafelyUnwrapped.initialize(to: previous)
    }

    @usableFromInline
    func createCopy() -> (head: UnsafeMutablePointer<Self>, tail: UnsafeMutablePointer<Self>) {
        let head = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        head.initialize(to: .init(element: element))
        var tail = head

        var current = next
        while current != nil {
            defer { current = current.unsafelyUnwrapped.pointee.next }
            tail.initializeNext(to: .init(element: current.unsafelyUnwrapped.pointee.element))
            tail = tail.pointee.next.unsafelyUnwrapped
        }

        return (head, tail)
    }
}

// MARK: - Extensions
extension UnsafeMutablePointer {
    /// Access through the pointer's `pointee` to set the `next` value and then have the `next.previous` point back at `self`
    ///
    /// - Precondition: `next.previous` must be `nil`
    /// - Precondition: `pointee.next` must be `nil`
    ///
    /// - Parameter next: The value of the `next` node that should be pointed to.
    @usableFromInline
    func initializeNext<Element>(to next: DoubleLinkedListNode<Element>) where Pointee == DoubleLinkedListNode<Element> {
        precondition(next.previous == nil)
        pointee.initializeNext(to: next)
        pointee.next.unsafelyUnwrapped.pointee.previous = self
    }

    /// Access through the pointer's `pointee` to set the `next` value and then have the `next.previous` point back at `self`
    ///
    /// - Precondition: `next.pointee.previous` must be `nil`
    /// - Precondition: `pointee.next` must be `nil`
    ///
    /// - Parameter next: A pointer to the `next` node that should be pointed to.
    @usableFromInline
    func initializeNext<Element>(to next: Self) where Pointee == DoubleLinkedListNode<Element> {
        precondition(next.pointee.previous == nil)
        precondition(pointee.next == nil)
        next.pointee.previous = self
        pointee.next = next
    }

    /// Access through the pointer's `pointee` to set the `previous` value and then have the `previous.next` point back at `self`
    ///
    /// - Precondition: `previous.next` must be `nil`
    /// - Precondition: `pointee.previous` must be `nil`
    ///
    /// - Parameter previous: The value of the `previous` node that should be pointed to.
    @usableFromInline
    func initializePrevious<Element>(to previous: DoubleLinkedListNode<Element>) where Pointee == DoubleLinkedListNode<Element> {
        precondition(previous.next == nil)
        pointee.initializePrevious(to: previous)
        pointee.previous.unsafelyUnwrapped.pointee.next = self
    }

    /// Access through the pointer's `pointee` to set the `previous` value and then have the `previous.next` point back at `self`
    ///
    /// - Precondition: `previous.pointee.next` must be `nil`
    /// - Precondition `pointee.previous` must be `nil`
    ///
    /// - Parameter previous: A pointer to the `previous` node that should be pointed to.
    @usableFromInline
    func initializePrevious<Element>(to previous: Self) where Pointee == DoubleLinkedListNode<Element> {
        precondition(previous.pointee.next == nil)
        precondition(pointee.previous == nil)
        previous.pointee.next = self
        pointee.previous = previous
    }
}
