//
//  OnDeinitTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import Foundation
@testable import SwiftPropertyWrappersSpellBook
import XCTest

final class OnDeinitTests: XCTestCase {
    @available(iOS 13.0, tvOS 13.0, *)
    func testPerformance1() {
        var total = 0
        measure(metrics: [XCTStorageMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            total = 0
            for i in 0..<10_000 {
                var value = OnDeinit<Int>(wrappedValue: i) { _ in
                    total += 1
                }
                XCTAssertEqual(value.wrappedValue, i)
                value.wrappedValue = Int.random(in: 1...10)
                value.wrappedValue += 1
            }
            XCTAssertEqual(total, 10_000)
        }
    }

    func testCopying() {
        var deinitTotal = 0
        var expectedTotal = 0
        do {
            var value = OnDeinit<Int>(wrappedValue: 42) { _ in
                deinitTotal += 1
            }
            expectedTotal += 1

            // This shouldn't make a copy since only the one reference exists
            value.unsafeMakeUnique()
            expectedTotal += 0

            let copy = value.unsafeCopy()
            XCTAssertEqual(copy, value)
            expectedTotal += 1

            // This shouldn't make a copy since only the one reference exists the unsafe copy isn't the same reference
            value.unsafeMakeUnique()
            expectedTotal += 0

            var extraReference = value
            XCTAssert(extraReference.box === value.box)
            extraReference.unsafeMakeUnique()
            expectedTotal += 1
        }
        XCTAssertEqual(deinitTotal, expectedTotal)
    }
}
#endif
