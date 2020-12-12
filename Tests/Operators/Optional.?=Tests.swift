//
//  Optional.?=Tests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftOperatorsSpellBook
import XCTest

final class OptionalAssignmentOperatorTests: XCTestCase {
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
}
#endif
