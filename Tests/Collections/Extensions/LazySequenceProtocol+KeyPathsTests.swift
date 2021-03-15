//
//  LazySequenceProtocol+KeyPathsTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/14/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class LazySequenceProtocolKeyPathsTests: XCTestCase {
    func testLazySequenceProtocolFilterKeyPathEqualTo() {
        var fail = true
        var called = false
        var equalTo: Int {
            if fail {
                XCTFail("Filter should be lazy")
            }
            called = true
            return 2
        }
        let numbers = (0b0001...0b1111).lazy
            .filter(\.nonzeroBitCount, equalTo: equalTo)

        fail.toggle()

        // Binary Digits: 1-16          | 2 Bits Set
        // -----------------------------------------
        // 0001, 0010, 0011, 0100, 0101 | 2
        // 0110, 0111, 1000, 1001, 1010 | 3
        // 1011, 1100, 1101, 1110, 1111 | 1
        XCTAssertEqual(numbers.count, 6)
        XCTAssert(called)
    }

    func testLazySequenceProtocolFilterKeyPathNotEqualTo() {
        var fail = true
        var called = false
        var notEqualTo: Int {
            if fail {
                XCTFail("Filter should be lazy")
            }
            called = true
            return 2
        }
        let numbers = (0b0001...0b1111).lazy
            .filter(\.nonzeroBitCount, notEqualTo: notEqualTo)

        fail.toggle()

        // Binary Digits: 1-16          | 2 Bits Set
        // -----------------------------------------
        // 0001, 0010, 0011, 0100, 0101 | 2
        // 0110, 0111, 1000, 1001, 1010 | 3
        // 1011, 1100, 1101, 1110, 1111 | 1
        XCTAssertEqual(numbers.count, 9)
        XCTAssert(called)
    }

    func testLazySequenceProtocolFilterSatisfies() {
        var fail = true
        var called = false
        let predicate: (Int) -> Bool = { value in
            if fail {
                XCTFail("Filter should be lazy")
            }
            called = true
            return value == 2
        }
        let numbers = (0b0001...0b1111).lazy
            .filter(\.nonzeroBitCount, satisifies: predicate)

        fail.toggle()

        // Binary Digits: 1-16          | 2 Bits Set
        // -----------------------------------------
        // 0001, 0010, 0011, 0100, 0101 | 2
        // 0110, 0111, 1000, 1001, 1010 | 3
        // 1011, 1100, 1101, 1110, 1111 | 1
        XCTAssertEqual(numbers.count, 6)
        XCTAssert(called)
    }
}
#endif
