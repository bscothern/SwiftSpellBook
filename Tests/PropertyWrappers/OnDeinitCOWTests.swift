//
//  OnDeinitCOWTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import Foundation
@testable import SwiftPropertyWrappersSpellBook
import XCTest

final class OnDeinitCOWTests: XCTestCase {
    @available(iOS 13.0, tvOS 13.0, *)
    func testPerformance1() {
        var total = 0
        measure(metrics: [XCTStorageMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            total = 0
            for i in 0..<10_000 {
                var value = OnDeinitCOW<Int>(wrappedValue: i) { _ in
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
        var expectedDeinitTotal = 0
        var expectedValue = 0
        do {
            var value = OnDeinitCOW<Int>(wrappedValue: 0) { _ in
                deinitTotal += 1
            }
            expectedDeinitTotal += 1
            
            // This shouldn't make a copy since only the one reference exists
            value.wrappedValue += 1
            expectedDeinitTotal += 0
            expectedValue += 1

            var copy = value
            XCTAssertEqual(copy, value)
            expectedDeinitTotal += 1
            copy.wrappedValue -= 1
            expectedValue += 0
            
            // This shouldn't make a copy since only the one reference exists the unsafe copy isn't the same reference
            value.wrappedValue += 3
            expectedDeinitTotal += 0
            expectedValue += 3
        }
        XCTAssertEqual(deinitTotal, expectedDeinitTotal)
    }
}
#endif
