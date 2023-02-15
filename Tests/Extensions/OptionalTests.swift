//
//  OptionalTests.swift
// github.com
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftExtensionsSpellBook
import XCTest

final class OptionalTests: XCTestCase {
    func testOptionalAssignmentOperator() {
        var value: Int?
        XCTAssertNil(value)

        value ?= 1
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 1)

        value ?= 2
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 1)
        XCTAssertNotEqual(value, 2)

        value = 3
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }

    func testDoubleOptionals() {
        var value: Int??
        XCTAssertNil(value as Any?)

        value ?= 1
        XCTAssertNotNil(value as Any?)
        XCTAssertEqual(value, 1)

        value ?= 2
        XCTAssertNotNil(value as Any?)
        XCTAssertEqual(value, 1)
        XCTAssertNotEqual(value, 2)

        value = .some(nil)
        XCTAssertNotNil(value as Any?)
        XCTAssertEqual(value, .some(nil))

        value ?= 4
        XCTAssertNotNil(value as Any?)
        XCTAssertEqual(value, .some(nil))
    }
}
#endif
