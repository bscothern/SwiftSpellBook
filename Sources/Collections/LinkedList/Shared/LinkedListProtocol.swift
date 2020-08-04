//
//  LinkedListProtocol.swift
//  ThingsMissingFromSwift
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public protocol LinkedListProtocol: Collection, ExpressibleByArrayLiteral {
    associatedtype Element
    
    /// Creates an empty linked list
    init()
    
    /// Adds a new element to the end of the linked list.
    ///
    /// - Parameter element: The element to append to the linked list.
    mutating func append(_ element: Element)
    
    /// Adds a new element to the start of the linked list.
    ///
    /// - Parameter element: The element to prepend to the linked list.
    mutating func prepend(_ element: Element)
    
    /// Inserts a new element at the specified position.
    ///
    /// - Parameters:
    ///   - element: The new element to insert into the linked list.
    ///   - i: The position at which `element` should be inserted.
    ///     This must be a valid index or `endIndex`.
    mutating func insert(_ element: Element, at i: Index)

    /// Removes and returns the first element of the linked list.
    ///
    /// The linked list must not be empty.
    ///
    /// - Returns: The element that was the first element of the linked list.
    @discardableResult
    mutating func removeFirst() -> Element
    
    /// Removes the first `n` elements from the linked list.
    ///
    /// The linked list must have at least `n` elements.
    ///
    /// - Parameter n: The number of elmenets to remove from the start of the linked list.
    mutating func removeFirst(_ n: Int)
    
    /// Removes and returns the first element of the linked list if it is not empty.
    ///
    /// - Returns: The element that was the first element of the linked list if not empty, otherwise `nil`.
    @discardableResult
    mutating func popFirst() -> Element?
    
//    /// Removes and returns the last element of the linked list.
//    ///
//    /// The linked list must not be empty.
//    ///
//    /// - Returns: The element that was the last element of the linked list.
//    @discardableResult
//    mutating func removeLast() -> Element
//
//    /// Removes the last `n` elements from the linked list.
//    ///
//    /// The linked list must have at least `n` elements.
//    ///
//    /// - Parameter n: The number of elmenets to remove from the end of the linked list.
//    mutating func removeLast(_ n: Int)
//
//    /// Removes and returns the last element of the linked list if it is not empty.
//    ///
//    /// - Returns: The element that was the last element of the linked list if not empty, otherwise `nil`.
//    @discardableResult
//    mutating func popLast() -> Element?
    
    /// Removes all elements from the linked list
    mutating func removeAll()
}

extension LinkedListProtocol {
    @inlinable
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }

    @inlinable
    public init<S>(_ sequence: S) where S: Sequence, S.Element == Element {
        self.init()
        sequence.forEach { element in
            append(element)
        }
    }
    
    @inlinable
    public mutating func removeAll() {
        self = .init()
    }
}

@usableFromInline
protocol _LinkedListProtocol: LinkedListProtocol {
    associatedtype Node: LinkedListNode where Node.Element == Element
    typealias  Buffer = LinkedListBuffer<Element, Node>
    
    var buffer: Buffer { get set }
}

extension _LinkedListProtocol {
    @usableFromInline
    mutating func createCopyIfNeeded() {
        guard !isKnownUniquelyReferenced(&buffer) else { return }
        buffer = buffer.createCopy()
    }
}

extension _LinkedListProtocol {
    @inlinable
    public var isEmpty: Bool { buffer.isEmpty }

    @inlinable
    public mutating func insert(_ element: Element, at i: Index) {
        createCopyIfNeeded()
        #warning("TODO")
    }
    
    @inlinable
    public mutating func removeFirst() -> Element {
        createCopyIfNeeded()
        return buffer.removeFirst()
    }
    
    @inlinable
    public mutating func removeFirst(_ n: Int) {
        createCopyIfNeeded()
        precondition(n < self.count, "\(#function) requires that n < self.count")
        for _ in 0..<n {
            buffer.removeFirst()
        }
    }
    
    @inlinable
    public mutating func popFirst() -> Element? {
        createCopyIfNeeded()
        return buffer.popFirst()
    }
//    @inlinable
//    public mutating func removeLast() -> Element {
//        createCopyIfNeeded()
//        return buffer.removeLast()
//    }
//
//    @inlinable
//    public mutating func removeLast(_ n: Int) {
//        createCopyIfNeeded()
//        precondition(n < self.count, "\(#function) requires that n < self.count")
//        for _ in 0..<n {
//            buffer.removeLast()
//        }
//    }
}
