//
//  EitherNoCollectionCOWTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

// These tests are only run in release mode that is when the ARC optomizations will take place to attempt to bypass COW issues.
// These tests can be run with: swift test -c release -Xswiftc -enable-testing
#if !os(watchOS) && !DEBUG
import ProtocolTests
@_spi(EitherMutableCollection)
import SwiftCollectionsSpellBook
import XCTest

final class EitherNoCollectionCOWTests: XCTestCase {
    func testNoCOW() throws {
        var either: Either<COWCollection<Int>, COWCollection<Int>> = .left([1, 3, 2])
        either.sort()
    }
}

struct COWCollection<Element>: MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, IsUnique {
    final class Buffer {
        var values: [Element]

        init(values: [Element] = []) {
            self.values = values
        }
    }

    struct Index: Comparable {
        let value: Array<Element>.Index

        static func < (lhs: COWCollection<Element>.Index, rhs: COWCollection<Element>.Index) -> Bool {
            lhs.value < rhs.value
        }
    }

    var buffer: Buffer

    var startIndex: Index {
        .init(value: buffer.values.startIndex)
    }

    var endIndex: Index {
        .init(value: buffer.values.endIndex)
    }

    init(arrayLiteral elements: Element...) {
        buffer = .init(values: elements)
    }

    func index(after i: Index) -> Index {
        .init(value: buffer.values.index(after: i.value))
    }

    func index(before i: Index) -> Index {
        .init(value: buffer.values.index(before: i.value))
    }

    subscript(position: Index) -> Element {
        get { buffer.values[position.value] }
        set {
            if !isKnownUniquelyReferenced(&buffer) {
                XCTFail("Buffer is referenced multiple times which would trigger copy on write")
                buffer = .init(values: buffer.values)
            }
            buffer.values[position.value] = newValue
        }
    }

    @_transparent
    mutating func isUnique() -> Bool {
        isKnownUniquelyReferenced(&buffer)
    }
}

#endif
