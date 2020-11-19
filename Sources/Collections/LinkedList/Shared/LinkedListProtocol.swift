//
//  LinkedListProtocol.swift
//  SwiftSpellBook
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
    ///   - index: The position at which `element` should be inserted.
    ///     This must be a valid index or `endIndex`.
    mutating func insert(_ element: Element, at index: Index)

    /// Removes the element at the specified postion.
    ///
    /// All elements following the specified index are moved up in the list.
    ///
    /// - Parameter index: The position of the elmenet to remove from the list.
    ///     This must be a valid index of the list.
    mutating func remove(at index: Index)

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
}

@usableFromInline
protocol _LinkedListProtocol: LinkedListProtocol where Index: LinkedListIndex, Index.Base == Self {
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
    public var startIndex: Index { .init(buffer.startIndex) }

    @inlinable
    public var endIndex: Index { .init(buffer.endIndex) }

    @inlinable
    public var isEmpty: Bool { buffer.isEmpty }

    @inlinable
    public var count: Int {
        // swiftlint doesn't recognize _modify as an accessor
        // swiftlint:disable:next implicit_getter
        get { buffer.count }
        _modify {
            defer { _fixLifetime(self) }
            yield &buffer.count
        }
    }

    @inlinable
    public func index(after i: Index) -> Index {
        .init(buffer.index(after: i.value))
    }

    @inlinable
    public subscript(position: Index) -> Element {
        buffer[position.value]
    }
}

extension _LinkedListProtocol {
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

    @inlinable
    public mutating func removeAll() {
        self = .init()
    }
}
