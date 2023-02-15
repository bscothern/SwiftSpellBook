//
//  OnDeinitTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import Foundation
@testable import SwiftPropertyWrappersSpellBook
import XCTest

final class OnDeinitTests: XCTestCase {
    let performanceTestIterations = 1_000_000

    @available(iOS 13.0, tvOS 13.0, *)
    func testPerformance() {
        let iterations = performanceTestIterations
        var total = 0
        measure(metrics: [XCTStorageMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            total = 0
            for i in (0..<iterations).reversed() {
                var value = OnDeinit<Int>(wrappedValue: i) { _ in
                    total += 1
                }
                XCTAssertEqual(value.wrappedValue, i)
                value.wrappedValue = Int.random(in: 1...10)
                value.wrappedValue += 1
            }
            XCTAssertEqual(total, iterations)
        }
    }

    #if PROPERTYWRAPPER_ON_DEINIT_BUFFERED
    @available(iOS 13.0, tvOS 13.0, *)
    func testPerformanceBuffered() {
        let iterations = performanceTestIterations
        var total = 0
        measure(metrics: [XCTStorageMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            total = 0
            for i in (0..<iterations).reversed() {
                let value = OnDeinitBuffered<Int>(wrappedValue: i) { _ in
                    total += 1
                }
                XCTAssertEqual(value.wrappedValue, i)
                value.wrappedValue = Int.random(in: 1...10)
                value.wrappedValue += 1
            }
            XCTAssertEqual(total, iterations)
        }
    }
    #endif

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
