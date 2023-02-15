//
//  AlwaysEqualTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class AlwaysEqualTests: XCTestCase {
    func testAlwaysEqual() {
        let value0 = AlwaysEqual(wrappedValue: 1)
        let value1 = AlwaysEqual(wrappedValue: 2)

        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value0.wrappedValue, value1.wrappedValue)
    }

    func testProjectedValue() {
        let value0 = AlwaysEqual(wrappedValue: 1)
        var value1 = value0.projectedValue

        value1.wrappedValue = 2

        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value0.wrappedValue, value1.wrappedValue)
    }
}
#endif
