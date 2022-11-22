//
//  DynamicDidSetTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/24/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class DynamicDidSetTests: XCTestCase {
    func testExpectedValueAndOldValue() {
        var didSetValue = 0
        var didSetOldValue = 0
        var called = false

        let expectedOldValue = 1
        let expectedValue = 2

        var value = DynamicDidSet(wrappedValue: expectedOldValue) { value, oldValue in
            didSetValue = value
            didSetOldValue = oldValue
            called = true
        }

        value.wrappedValue = expectedValue
        XCTAssertEqual(didSetValue, expectedValue)
        XCTAssertEqual(didSetOldValue, expectedOldValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedValue)
    }

    func testExpectedValueAndOldValueModified() {
        var didSetValue = 0
        var didSetOldValue = 0
        var called = false

        let expectedOldValue = 1
        let expectedValue = 2

        var value = DynamicDidSet(wrappedValue: expectedOldValue) { value, oldValue in
            didSetValue = value
            didSetOldValue = oldValue
            called = true
        }

        value.wrappedValue += 1
        XCTAssertEqual(didSetValue, expectedValue)
        XCTAssertEqual(didSetOldValue, expectedOldValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedValue)
    }

    func testProjectedValueExpectedValueAndOldValue() {
        var didSetValue = 0
        var didSetOldValue = 0
        var called = false

        let expectedOldValue = 1
        let expectedValue = 2

        var value = DynamicDidSet(wrappedValue: expectedOldValue) { value, oldValue in
            didSetValue = value
            didSetOldValue = oldValue
            called = true
        }

        value.projectedValue.wrappedValue = expectedValue
        XCTAssertEqual(didSetValue, expectedValue)
        XCTAssertEqual(didSetOldValue, expectedOldValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedValue)
    }

    func testProjectedValueExpectedValueAndOldValueModified() {
        var didSetValue = 0
        var didSetOldValue = 0
        var called = false

        let expectedOldValue = 1
        let expectedValue = 2

        var value = DynamicDidSet(wrappedValue: expectedOldValue) { value, oldValue in
            didSetValue = value
            didSetOldValue = oldValue
            called = true
        }

        value.projectedValue.wrappedValue += 1
        XCTAssertEqual(didSetValue, expectedValue)
        XCTAssertEqual(didSetOldValue, expectedOldValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedValue)
    }

    func testProjectedValueAssignmet() {
        var didSetValue = 0
        var didSetOldValue = 0
        var called = false

        let expectedOldValue = 1
        let expectedValue = 2

        var value = DynamicDidSet(wrappedValue: expectedOldValue) { value, oldValue in
            didSetValue = value
            didSetOldValue = oldValue
            called = true
        }

        let projected = value.projectedValue
        value.projectedValue = .init(wrappedValue: 1)

        value.wrappedValue += 1
        XCTAssertNotEqual(didSetValue, expectedValue)
        XCTAssertNotEqual(didSetOldValue, expectedOldValue)
        XCTAssertFalse(called)
        XCTAssertEqual(value.wrappedValue, expectedValue)
        XCTAssertNil(value.didSet)

        XCTAssertNotEqual(value.wrappedValue, projected.wrappedValue)
    }

    func testProjectedValueCopies() {
        var didSetValue = 0
        var didSetOldValue = 0
        var called = false

        let expectedOldValue = 1
        let expectedValue = 2

        var value = DynamicDidSet(wrappedValue: expectedOldValue) { value, oldValue in
            didSetValue = value
            didSetOldValue = oldValue
            called = true
        }

        let projected = value.projectedValue

        value.wrappedValue += 1
        XCTAssertEqual(didSetValue, expectedValue)
        XCTAssertEqual(didSetOldValue, expectedOldValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedValue)

        XCTAssertNotEqual(value.wrappedValue, projected.wrappedValue)
    }
}
#endif
