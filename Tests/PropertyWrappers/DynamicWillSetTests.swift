//
//  DynamicWillSetTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/24/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class DynamicWillSetTests: XCTestCase {
    func testExpectedValueAndNewValue() {
        var willSetValue = 0
        var willSetNewValue = 0
        var called = false

        let expectedValue = 1
        let expectedNewValue = 2

        var value = DynamicWillSet(wrappedValue: expectedValue) { value, newValue in
            willSetValue = value
            willSetNewValue = newValue
            called = true
        }

        value.wrappedValue = expectedNewValue
        XCTAssertEqual(willSetValue, expectedValue)
        XCTAssertEqual(willSetNewValue, expectedNewValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedNewValue)
    }

    func testExpectedValueAndNewValueModified() {
        var willSetValue = 0
        var willSetNewValue = 0
        var called = false

        let expectedValue = 1
        let expectedNewValue = 2

        var value = DynamicWillSet(wrappedValue: expectedValue) { value, newValue in
            willSetValue = value
            willSetNewValue = newValue
            called = true
        }

        value.wrappedValue += 1
        XCTAssertEqual(willSetValue, expectedValue)
        XCTAssertEqual(willSetNewValue, expectedNewValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedNewValue)
    }

    func testProjectedValueExpectedValueAndNewValue() {
        var willSetValue = 0
        var willSetNewValue = 0
        var called = false

        let expectedValue = 1
        let expectedNewValue = 2

        var value = DynamicWillSet(wrappedValue: expectedValue) { value, newValue in
            willSetValue = value
            willSetNewValue = newValue
            called = true
        }

        value.projectedValue.wrappedValue = expectedNewValue
        XCTAssertEqual(willSetValue, expectedValue)
        XCTAssertEqual(willSetNewValue, expectedNewValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedNewValue)
    }

    func testProjectedValueExpectedValueAndNewValueModified() {
        var willSetValue = 0
        var willSetNewValue = 0
        var called = false

        let expectedValue = 1
        let expectedNewValue = 2

        var value = DynamicWillSet(wrappedValue: expectedValue) { value, newValue in
            willSetValue = value
            willSetNewValue = newValue
            called = true
        }

        value.projectedValue.wrappedValue += 1
        XCTAssertEqual(willSetValue, expectedValue)
        XCTAssertEqual(willSetNewValue, expectedNewValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedNewValue)
    }

    func testProjectedValueAssignmet() {
        var willSetValue = 0
        var willSetNewValue = 0
        var called = false

        let expectedValue = 1
        let expectedNewValue = 2

        var value = DynamicWillSet(wrappedValue: expectedValue) { value, newValue in
            willSetValue = value
            willSetNewValue = newValue
            called = true
        }

        let projected = value.projectedValue
        value.projectedValue = .init(wrappedValue: 1)

        value.wrappedValue += 1
        XCTAssertNotEqual(willSetValue, expectedValue)
        XCTAssertNotEqual(willSetNewValue, expectedNewValue)
        XCTAssertFalse(called)
        XCTAssertEqual(value.wrappedValue, expectedNewValue)
        XCTAssertNil(value.willSet)

        XCTAssertNotEqual(value.wrappedValue, projected.wrappedValue)
    }

    func testProjectedValueCopies() {
        var willSetValue = 0
        var willSetNewValue = 0
        var called = false

        let expectedValue = 1
        let expectedNewValue = 2

        var value = DynamicWillSet(wrappedValue: expectedValue) { value, newValue in
            willSetValue = value
            willSetNewValue = newValue
            called = true
        }

        let projected = value.projectedValue

        value.wrappedValue += 1
        XCTAssertEqual(willSetValue, expectedValue)
        XCTAssertEqual(willSetNewValue, expectedNewValue)
        XCTAssert(called)
        XCTAssertEqual(value.wrappedValue, expectedNewValue)

        XCTAssertNotEqual(value.wrappedValue, projected.wrappedValue)
    }
}
#endif
