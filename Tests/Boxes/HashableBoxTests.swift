//
//  HashableBoxTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/25/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_CheckXCAssertionFailure
import LoftTest_StandardLibraryProtocolChecks
import SwiftBoxesSpellBook
import XCTest

// swiftlint:disable trailing_closure
final class HashableBoxTests: CheckXCAssertionFailureTestCase {
    func testAreEqual() {
        let value1 = HashableBox(1, areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })
        let value2 = HashableBox(2, areEqualBy: { _, _ in true }, hashedBy: { hasher, _ in hasher.combine(#function) })

        value1.checkHashableLaws()
        value2.checkHashableLaws()
        value1.checkHashableLaws(equal: value2)

        XCTAssertEqual(value1, value2)
        XCTAssertEqual(value1.hashValue, value2.hashValue)
    }

    func testAreNotEqual1() {
        let value1 = HashableBox(1, areEqualBy: ==, hashedBy: { hasher, _ in hasher.combine(#function) })
        let value2 = HashableBox(2, areEqualBy: ==, hashedBy: { hasher, _ in hasher.combine(#function) })

        value1.checkHashableLaws()
        value2.checkHashableLaws()
        checkXCAssertionFailure(
            value1.checkHashableLaws(equal: value2)
        )

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
// swiftlint:enable trailing_closure
#endif
