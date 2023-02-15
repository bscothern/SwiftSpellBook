//
//  Sequence+KeyPathsTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/21/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class SequenceKeyPathsTests: XCTestCase {
    func testAssign() {
        class Foo {
            var i = 0
        }

        let number = Int.random(in: 1...10)

        func applyAssign<S>(to sequence: S) where S: Sequence, S.Element == Foo {
            sequence.assign(number, to: \.i)
        }

        let foos = [Foo(), Foo(), Foo()]
        applyAssign(to: foos)

        XCTAssertEqual(foos.map(\.i), Array(repeating: number, count: foos.count))
    }

    func testReduce() {
        struct Foo {
            var i: Int
        }

        let range = 0..<10
        let expected = range.reduce(-1, +)

        let foos = range.map(Foo.init(i:))
        let reducedValue = foos.reduce(\.i, initialValue: -1, +)

        XCTAssertEqual(reducedValue, expected)
    }

    func testReduceInto() {
        struct Foo {
            var i: Int
        }

        let range = 0..<10
        let expected = range.reduce(into: -1, +=)

        let foos = range.map(Foo.init(i:))
        let reducedValue = foos.reduce(\.i, into: -1, +=)

        XCTAssertEqual(reducedValue, expected)
    }

    func testSeqeunceFilterKeyPathEqualTo() {
        var called = false
        var equalTo: Int {
            called = true
            return 2
        }
        let numbers = (0b0001...0b1111)
            .filter(\.nonzeroBitCount, equalTo: equalTo)

        XCTAssert(called)

        // Binary Digits: 1-16          | 2 Bits Set
        // -----------------------------------------
        // 0001, 0010, 0011, 0100, 0101 | 2
        // 0110, 0111, 1000, 1001, 1010 | 3
        // 1011, 1100, 1101, 1110, 1111 | 1
        XCTAssertEqual(numbers.count, 6)
    }

    func testSeqeunceFilterKeyPathNotEqualTo() {
        var called = false
        var notEqualTo: Int {
            called = true
            return 2
        }
        let numbers = (0b0001...0b1111)
            .filter(\.nonzeroBitCount, notEqualto: notEqualTo)

        XCTAssert(called)

        // Binary Digits: 1-16          | 2 Bits Set
        // -----------------------------------------
        // 0001, 0010, 0011, 0100, 0101 | 2
        // 0110, 0111, 1000, 1001, 1010 | 3
        // 1011, 1100, 1101, 1110, 1111 | 1
        XCTAssertEqual(numbers.count, 9)
    }

    func testSeqeunceFilterSatisfies() {
        var called = false
        let predicate: (Int) -> Bool = { value in
            called = true
            return value == 2
        }
        let numbers = (0b0001...0b1111)
            .filter(\.nonzeroBitCount, satisifies: predicate)

        XCTAssert(called)

        // Binary Digits: 1-16          | 2 Bits Set
        // -----------------------------------------
        // 0001, 0010, 0011, 0100, 0101 | 2
        // 0110, 0111, 1000, 1001, 1010 | 3
        // 1011, 1100, 1101, 1110, 1111 | 1
        XCTAssertEqual(numbers.count, 6)
    }
}
#endif
