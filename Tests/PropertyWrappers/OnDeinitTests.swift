//
//  OnDeinitTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import Foundation
import SwiftPropertyWrappersSpellBook
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
}
#endif
