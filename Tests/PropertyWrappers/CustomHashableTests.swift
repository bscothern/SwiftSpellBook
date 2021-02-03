//
//  CustomHashableTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/12/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class CustomHashableTests: XCTestCase {
    func testCustomHashable() {
        // This test doesn't care to actually respect what being Hashable actually means. It simply wants to make sure that CustomHashable works correctly.
        let value0 = CustomHashable<Int>(wrappedValue: 1) { hasher, value in
            hasher.combine(value)
        }
        var value1 = CustomHashable<Int>(wrappedValue: 1) { hasher, value in
            hasher.combine(-value)
        }

        XCTAssertEqual(value0, value1)
        XCTAssertNotEqual(value0.hashValue, value1.hashValue)

        value1.wrappedValue *= -1
        XCTAssertNotEqual(value0, value1)
        XCTAssertEqual(value0.hashValue, value1.hashValue)

        value1.wrappedValue = value0.wrappedValue
        XCTAssertEqual(value0, value1)
        XCTAssertEqual(value0.wrappedValue, value1.wrappedValue)
        XCTAssertNotEqual(value0.hashValue, value1.hashValue)
    }
}
#endif
