//
//  CustomEquatableTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/12/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class CustomEquatableTests: XCTestCase {
    func testCustomEquatable() {
        let value0 = CustomEquatable<Int>(wrappedValue: 1) { _, _ in true }
        var value1 = CustomEquatable<Int>(wrappedValue: 2) { _, _ in false }

        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value1, value0)
        XCTAssertNotEqual(value0.wrappedValue, value1.wrappedValue)

        value1.wrappedValue = value0.wrappedValue
        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value1, value0)
        XCTAssertEqual(value0.wrappedValue, value1.wrappedValue)

        value1.wrappedValue = 3
        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value1, value0)
        XCTAssertNotEqual(value0.wrappedValue, value1.wrappedValue)

        value1.wrappedValue += 3
        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value1, value0)
        XCTAssertNotEqual(value0.wrappedValue, value1.wrappedValue)
    }
}
#endif
