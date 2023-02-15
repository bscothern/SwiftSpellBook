//
//  IndirectTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/12/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class IndirectTests: XCTestCase {
    struct Value {
        @Indirect
        var i: Int
    }

    func testRecursiveStruct() {
        // Ensure we can define a recursive struct
        struct Recursive {
            @Indirect
            var recursive: Recursive
        }
    }

    func testUseIndirect() {
        var value = Value(i: 1)
        XCTAssertEqual(value.i, 1)

        value.i += 1
        XCTAssertEqual(value.i, 2)

        value.i = 3
        XCTAssertEqual(value.i, 3)
    }

    func testProjectedValue() {
        let value = Value(i: 42)
        var projected = value.$i

        XCTAssertEqual(value.i, projected.wrappedValue)

        projected.wrappedValue += 1
        XCTAssertNotEqual(value.i, projected.wrappedValue)
    }
}
#endif
