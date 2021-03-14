////
////  EitherNoCollectionCOWTests.swift
////  SwiftSpellBookTests
////
////  Created by Braden Scothern on 12/2/20.
////  Copyright © 2020-2021 Braden Scothern. All rights reserved.
////
//
//#if !os(watchOS)
//import ProtocolTests
//import SwiftCollectionsSpellBook
//import XCTest
//
//final class EitherNoCollectionCOWTests: XCTestCase {
//    override func setUp() {
//        super.setUp()
//        self.continueAfterFailure = false
//    }
//
//    func testNoCOWLeft() throws {
//        var either: Either<COWCollection<Int>, COWCollection<Int>> = .left([1, 3, 2])
//        either[.left(.init(value: 1))] = 4
//
//        XCTAssertEqual(either[.left(.init(value: 1))], 4)
//        XCTAssertEqual(either.left.map(Array.init), [1, 4, 2])
//    }
//
//    func testNoCOWRight() throws {
//        var either: Either<COWCollection<Int>, COWCollection<Int>> = .right([1, 3, 2])
//        either[.right(.init(value: 1))] = 4
//
//        XCTAssertEqual(either[.right(.init(value: 1))], 4)
//        XCTAssertEqual(either.right.map(Array.init), [1, 4, 2])
//    }
//}
//
//struct COWCollection<Element>: MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral {
//    final class Buffer {
//        var values: [Element]
//
//        init(values: [Element] = []) {
//            self.values = values
//        }
//    }
//
//    struct Index: Comparable {
//        let value: Array<Element>.Index
//
//        static func < (lhs: COWCollection<Element>.Index, rhs: COWCollection<Element>.Index) -> Bool {
//            lhs.value < rhs.value
//        }
//    }
//
//    var buffer: Buffer
//
//    var startIndex: Index {
//        .init(value: buffer.values.startIndex)
//    }
//
//    var endIndex: Index {
//        .init(value: buffer.values.endIndex)
//    }
//
//    init(arrayLiteral elements: Element...) {
//        buffer = .init(values: elements)
//    }
//
//    func index(after i: Index) -> Index {
//        .init(value: buffer.values.index(after: i.value))
//    }
//
//    func index(before i: Index) -> Index {
//        .init(value: buffer.values.index(before: i.value))
//    }
//
//    mutating func append(_ element: Element) {
//        assertUnique()
//        buffer.values.append(element)
//    }
//
//    subscript(position: Index) -> Element {
//        get { buffer.values[position.value] }
//        set {
//            assertUnique()
//            buffer.values[position.value] = newValue
//        }
//    }
//
//    @_transparent
//    mutating func assertUnique() {
//        guard isKnownUniquelyReferenced(&buffer) else {
//            XCTFail("Buffer is referenced multiple times which would trigger copy on write")
//            return
//        }
//    }
//}
//
//#endif
