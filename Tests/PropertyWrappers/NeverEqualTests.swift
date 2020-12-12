//
//  NeverEqualTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class NeverEqualTests: XCTestCase {
    func testNeverEqual() {
        let value0 = NeverEqual(wrappedValue: 1)
        let value1 = NeverEqual(wrappedValue: 1)

        XCTAssertNotEqual(value0, value1)
        XCTAssertEqual(value0.wrappedValue, value1.wrappedValue)
    }
}
#endif
