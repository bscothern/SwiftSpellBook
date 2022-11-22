//
//  EquatableBoxTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/25/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_CheckXCAssertionFailure
import LoftTest_StandardLibraryProtocolChecks
import SwiftBoxesSpellBook
import XCTest

// swiftlint:disable trailing_closure
final class EquatableBoxTests: CheckXCAssertionFailureTestCase {
    func testAreEqual() {
        let value1 = EquatableBox(1, areEqualBy: { _, _ in true })
        let value2 = EquatableBox(2, areEqualBy: { _, _ in true })

        value1.checkEquatableLaws()
        value2.checkEquatableLaws()
        value1.checkEquatableLaws(equal: value2)
    }

    func testAreNotEqual() {
        let value1 = EquatableBox(1, areEqualBy: ==)
        let value2 = EquatableBox(2, areEqualBy: ==)

        value1.checkEquatableLaws()
        value2.checkEquatableLaws()
        checkXCAssertionFailure(
            value1.checkEquatableLaws(equal: value2)
        )
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
// swiftlint:enable trailing_closure
#endif
