//
//  OrderedSet.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 11/10/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

public struct OrderedSet<Element>: Hashable where Element: Hashable {
    @usableFromInline
    var set: Set<Element>

    @usableFromInline
    var order: [Element]

    @usableFromInline
    init(set: Set<Element>, order: [Element]) {
        self.set = set
        self.order = order
    }

    @inlinable
    public init() {
        self.init(
            set: .init(),
            order: .init()
        )
    }

    @inlinable
    public init(minimumCapacity: Int) {
        self.init(
            set: .init(minimumCapacity: minimumCapacity),
            order: .init(minimumCapacity: minimumCapacity)
        )
    }
}

extension OrderedSet {
    @inlinable
    public var capacity: Int { Swift.min(set.capacity, order.capacity) }

    @inlinable
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        set.reserveCapacity(minimumCapacity)
        order.reserveCapacity(minimumCapacity)
    }

    @inlinable
    public mutating func removeAll(keepingCapacity: Bool = false) {
        set.removeAll(keepingCapacity: keepingCapacity)
        order.removeAll(keepingCapacity: keepingCapacity)
    }

    @inlinable
    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> Self {
        var copy = self
        let partitionIndex = try copy.order.stablePartition { try !isIncluded($0) }
        copy.set.subtract(copy.order[partitionIndex...])
        copy.order[partitionIndex...].removeAll()
        return copy
    }

    @inlinable
    public func reversed() -> Self {
        var copy = self
        copy.reverse()
        return copy
    }

    @inlinable
    public mutating func reverse() {
        order.reverse()
    }

    @inlinable
    public func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> Self {
        var copy = self
        copy.sort(by: areInIncreasingOrder)
        return copy
    }

    @inlinable
    public mutating func sort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        order.sort(by: areInIncreasingOrder)
    }

    @inlinable
    public func shuffled() -> Self {
        var copy = self
        copy.shuffle()
        return copy
    }

    @inlinable
    public mutating func shuffle() {
        order.shuffle()
    }

    @inlinable
    public mutating func swapAt(_ i: Index, _ j: Index) {
        order.swapAt(i, j)
    }
}

extension OrderedSet where Element: Comparable {
    @inlinable
    public func sorted() -> Self {
        var copy = self
        copy.sort()
        return copy
    }

    @inlinable
    public mutating func sort() {
        order.sort()
    }
}

extension OrderedSet: Collection {
    public typealias Index = Array<Element>.Index

    @inlinable
    public var startIndex: Index { order.startIndex }

    @inlinable
    public var endIndex: Index { order.endIndex }

    @inlinable
    public var isEmpty: Bool { `set`.isEmpty }

    @inlinable
    public subscript(position: Index) -> Element {
        order[position]
    }

    @inlinable
    public func index(after i: Index) -> Index {
        order.index(after: i)
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        order.index(i, offsetBy: distance)
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        order.index(i, offsetBy: distance, limitedBy: limit)
    }
}

extension OrderedSet: SetAlgebra {
    @inlinable
    public func contains(_ member: Element) -> Bool {
        set.contains(member)
    }

    @inlinable
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let insertResult = set.insert(newMember)
        if insertResult.inserted {
            order.append(newMember)
        }
        return insertResult
    }

    @inlinable
    public mutating func update(with newMember: Element) -> Element? {
        let oldMember = set.update(with: newMember)
        if let oldMember = oldMember {
            if let index = order.firstIndex(of: oldMember) {
                order[index] = newMember
            } else {
                preconditionFailure("OrderedSet inconsistency. The set and array don't match.")
            }
        } else {
            order.append(newMember)
        }
        return oldMember
    }

    @inlinable
    public mutating func remove(_ member: Element) -> Element? {
        guard let result = set.remove(member) else {
            return nil
        }

        if let resultIndex = order.firstIndex(of: result) {
            order.remove(at: resultIndex)
        } else {
            preconditionFailure("OrderedSet inconsistency. The set and array don't match.")
        }
        return result
    }

    @inlinable
    public func union(_ other: Self) -> Self {
        var copy = self
        copy.formUnion(other)
        return copy
    }

    @inlinable
    public mutating func formUnion(_ other: Self) {
        for element in other {
            guard set.insert(element).inserted else {
                continue
            }
            order.append(element)
        }
    }

    @inlinable
    public func intersection(_ other: Self) -> Self {
        var copy = self
        copy.formIntersection(other)
        return copy
    }

    @inlinable
    public mutating func formIntersection(_ other: Self) {
        let partitionsIndex = order.stablePartition {
            !other.contains($0)
        }
        set.formIntersection(order[partitionsIndex...])
        order[partitionsIndex...].removeAll()
    }

    @inlinable
    public func symmetricDifference(_ other: Self) -> Self {
        var copy = self
        copy.formSymmetricDifference(other)
        return copy
    }

    @inlinable
    public mutating func formSymmetricDifference(_ other: Self) {
        let intersection = self.intersection(other)
        formUnion(other)
        subtract(intersection)
    }

    @inlinable
    public func isStrictSubset(of other: Self) -> Bool {
        set.isStrictSubset(of: other.set)
    }

    @inlinable
    public func isStrictSuperset(of other: Self) -> Bool {
        set.isStrictSuperset(of: other.set)
    }

    @inlinable
    public func isDisjoint(with other: Self) -> Bool {
        set.isDisjoint(with: other.set)
    }

    @inlinable
    public func isSubset(of other: Self) -> Bool {
        set.isSubset(of: other.set)
    }

    @inlinable
    public func isSuperset(of other: Self) -> Bool {
        set.isSuperset(of: other.set)
    }

    @inlinable
    public mutating func subtract(_ other: Self) {
        let partitionIndex = order.stablePartition(by: other.contains)
        order[partitionIndex...].removeAll()
        set.subtract(other.set)
    }

    @inlinable
    public func subtracting(_ other: Self) -> Self {
        var copy = self
        copy.subtract(other)
        return copy
    }
}

extension OrderedSet: Encodable where Element: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(order)
    }
}

extension OrderedSet: Decodable where Element: Decodable {
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let order = try container.decode([Element].self)
        self.init(
            set: .init(order),
            order: order
        )
    }
}
