//
//  EquatableBoxTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/25/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import ProtocolTests
import SwiftBoxesSpellBook
import XCTest

final class EquatableBoxTests: XCTestCase, EquatableTests {
    typealias EquatableValue = EquatableBox<Int>

    var testableValueRequestIDRange: Range<Int> = 0..<100

    func equatableValue(requestID: Int) -> EquatableBox<Int> {
        .init(requestID, areEqualBy: ==)
    }

    func testRunEqutableTests() throws {
        try runEquatableTests()
    }

    func testAreEqual() {
        let value1 = EquatableBox(1, areEqualBy: { _, _ in true })
        let value2 = EquatableBox(2, areEqualBy: { _, _ in true })

        XCTAssertEqual(value1, value2)
    }

    func testAreNotEqual() {
        let value1 = EquatableBox(1, areEqualBy: { _, _ in false })
        let value2 = EquatableBox(2, areEqualBy: { _, _ in false })

        XCTAssertNotEqual(value1, value2)
    }

    func testKeyPath() {
        let value = EquatableBox(42, areEqualBy: { _, _ in true })
        XCTAssertEqual(value.magnitude, 42)
    }

    struct Foo {
        var i = 0
    }

    func testWritableKeyPath() {
        var value = EquatableBox(Foo(), areEqualBy: { _, _ in true })
        value.i = 1
        value.i += 1
        XCTAssertEqual(value.i, 2)
    }

    class Bar {
        var i = 0
    }

    func testReferenceWritableKeyPath() {
        var value = EquatableBox(Bar(), areEqualBy: { _, _ in true })
        value.i = 1
        value.i += 1
        XCTAssertEqual(value.i, 2)
    }
}
#endif
