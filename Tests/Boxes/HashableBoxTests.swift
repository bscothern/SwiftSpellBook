//
//  HashableBoxTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/25/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import ProtocolTests
import SwiftBoxesSpellBook
import XCTest

final class HashableBoxTests: XCTestCase, HashableTests {
    typealias HashableValue = HashableBox<Int>
    typealias EquatableValue = HashableValue

    let testableValueRequestIDRange: Range<Int> = 10..<11

    func hashableValue(requestID: Int) -> HashableBox<Int> {
        .init(requestID, areEqualBy: ==, hashedBy: { hasher, boxedValue in
            XCTAssertEqual(boxedValue, requestID)
            hasher.combine(boxedValue)
        })
    }

    func testRunHashableTests() throws {
        try runHashableTests()
    }

    func testAreEqual() {
        let value1 = HashableBox(1, areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })
        let value2 = HashableBox(2, areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })

        XCTAssertEqual(value1, value2)
        XCTAssertEqual(value1.hashValue, value2.hashValue)
    }

    func testAreNotEqual1() {
        let value1 = HashableBox(1, areEqualBy: { _, _ in false }, hashedBy: { hasher, _ in hasher.combine(#function) })
        let value2 = HashableBox(2, areEqualBy: { _, _ in false }, hashedBy: { hasher, _ in hasher.combine(#function) })

        XCTAssertNotEqual(value1, value2)
        XCTAssertEqual(value1.hashValue, value2.hashValue)
    }

    func testAreNotEqual2() {
        let value1 = HashableBox(1, areEqualBy: { _, _ in false }, hashedBy: { hasher, _ in hasher.combine(#function) })
        let value2 = HashableBox(2, areEqualBy: { _, _ in false }, hashedBy: { hasher, _ in hasher.combine(#function.reversed()) })

        XCTAssertNotEqual(value1, value2)
        XCTAssertNotEqual(value1.hashValue, value2.hashValue)
    }

    func testKeyPath() {
        let value = HashableBox(42, areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })
        XCTAssertEqual(value.magnitude, 42)
    }

    struct Foo {
        var i = 0
    }

    func testWritableKeyPath() {
        var value = HashableBox(Foo(), areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })
        value.i = 1
        value.i += 1
        XCTAssertEqual(value.i, 2)
    }

    class Bar {
        var i = 0
    }

    func testReferenceWritableKeyPath() {
        var value = HashableBox(Bar(), areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })
        value.i = 1
        value.i += 1
        XCTAssertEqual(value.i, 2)
    }
}
#endif
