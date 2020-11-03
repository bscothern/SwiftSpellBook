//
//  BidirectionalDictionary.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import SwiftMemoryManagementSpellBook

public struct BidirectionalDictionary<T, U>: Collection where T: Hashable, U: Hashable {
    public struct Index: Comparable {
        @usableFromInline
        var value: Dictionary<T, U>.Index

        @usableFromInline
        init(_ value: Dictionary<T, U>.Index) {
            self.value = value
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.value < rhs.value
        }
    }

    @usableFromInline
    typealias Buffer = SafeManagedBuffer<Void, (tToU: [T: U], uToT: [U: T])>

    @usableFromInline
    var buffer = Buffer(minimumCapacity: 1, deinitStrategy: .minimumCapacity)

    @inlinable
    public init() {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU = .init()
            element.pointee.uToT = .init()
        }
    }

    @inlinable
    public init(minimumCapacity: Int) {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU = .init(minimumCapacity: minimumCapacity)
            element.pointee.uToT = .init(minimumCapacity: minimumCapacity)
        }
    }

    @inlinable
    public var startIndex: Index {
        .init(buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.startIndex
        })
    }

    @inlinable
    public var endIndex: Index {
        .init(buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.endIndex
        })
    }

    @inlinable
    public var count: Int {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.count
        }
    }

    @inlinable
    public var isEmpty: Bool {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.isEmpty
        }
    }

    @inlinable
    public var tValues: Dictionary<T, U>.Keys {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.keys
        }
    }

    @inlinable
    public var uValues: Dictionary<U, T>.Keys {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.uToT.keys
        }
    }

    @inlinable
    public func index(after i: Index) -> Index {
        .init(buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.index(after: i.value)
        })
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        .init(buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.index(i.value, offsetBy: distance)
        })
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.index(i.value, offsetBy: distance, limitedBy: limit.value)
        }.map(Index.init)
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.distance(from: start.value, to: end.value)
        }
    }

    @inlinable
    public subscript(position: Index) -> (T, U) {
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU[position.value]
        }
    }

    @inlinable
    public subscript(t: T) -> U? {
        get {
            buffer.withUnsafeMutablePointerToElements { element in
                element.pointee.tToU[t]
            }
        }
        set { updateValues(t, newValue) }
    }

    @inlinable
    public subscript(u: U) -> T? {
        get {
            buffer.withUnsafeMutablePointerToElements { element in
                element.pointee.uToT[u]
            }
        }
        set { updateValues(newValue, u) }
    }

    @inlinable
    @discardableResult
    public mutating func updateValues(_ t: T?, _ u: U?) -> (t: T?, u: U?) {
        makeBufferUniqueIfNeeded()
        var oldValues: (t: T?, u: U?) = (nil, nil)
        buffer.withUnsafeMutablePointerToElements { element in
            if let t = t,
               let u = u {
                oldValues.u = element.pointee.tToU.updateValue(u, forKey: t)
                oldValues.t = element.pointee.uToT.updateValue(t, forKey: u)
            } else if let t = t,
                      let u = element.pointee.tToU.removeValue(forKey: t) {
                oldValues.u = u
                oldValues.t = element.pointee.uToT.removeValue(forKey: u)
            } else if let u = u,
                      let t = element.pointee.uToT.removeValue(forKey: u) {
                oldValues.t = t
                oldValues.u = element.pointee.tToU.removeValue(forKey: t)
            }
        }
        return oldValues
    }

    @inlinable
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        makeBufferUniqueIfNeeded()
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.reserveCapacity(minimumCapacity)
            element.pointee.uToT.reserveCapacity(minimumCapacity)
        }
    }

    @inlinable
    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        makeBufferUniqueIfNeeded()
        buffer.withUnsafeMutablePointerToElements { element in
            element.pointee.tToU.removeAll(keepingCapacity: keepCapacity)
            element.pointee.uToT.removeAll(keepingCapacity: keepCapacity)
        }
    }
    
//    @inlinable
//    public mutating func merge(_ dictionary: [T: U], uniquingValuesWith: (_ current: (t: T, u: U), _ other: (t: T, u: U)) -> (t: T, u: U)) {
//        makeBufferUniqueIfNeeded()
//        buffer.withUnsafeMutablePointerToElements { element in
//            dictionary.forEach { pair in]
//                var toInsert = (t: pair.key, u: pair.value)
//                if element.pointee.tToU[pair.key] != nil {
//                    
//                }
//                if element.pointee.uToT[pair.value] != nil {
//                    
//                }
//            }
//        }
//    }

    @usableFromInline
    mutating func makeBufferUniqueIfNeeded() {
        guard !isKnownUniquelyReferenced(&buffer) else { return }

        let newBuffer = Buffer(minimumCapacity: 1, deinitStrategy: .minimumCapacity)

        buffer.withUnsafeMutablePointers { oldHeader, oldElements in
            newBuffer.withUnsafeMutablePointers { header, elements in
                header.pointee = oldHeader.pointee
                elements.pointee = oldElements.pointee
            }
        }

        buffer = newBuffer
    }
}
