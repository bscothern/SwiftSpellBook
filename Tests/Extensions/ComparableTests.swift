//
//  ComparableTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftExtensionsSpellBook
import XCTest

final class ComparableTests: XCTestCase {
    func testClamp() {
        let lowerMax = 40
        let upperMin = 60
        let min = 0
        let max = 100
        let step = 1
        let minimumContained = Array(stride(from: lowerMax, through: upperMin, by: step)).count
        for _ in 0..<100 {
            var containedValue = 0
            let lower = Int.random(in: min + step..<lowerMax)
            let upper = Int.random(in: upperMin..<max)
            for originalValue in stride(from: min, through: max, by: step) {
                var value = originalValue
                value.clamp(to: lower...upper)

                XCTAssertGreaterThanOrEqual(value, lower)
                XCTAssertLessThanOrEqual(value, upper)

                if value == originalValue {
                    containedValue += 1
                }
            }

            XCTAssertGreaterThanOrEqual(containedValue, minimumContained)
        }
    }

    func testClamped() {
        let lowerMax = 40
        let upperMin = 60
        let min = 0
        let max = 100
        let step = 1
        let minimumContained = Array(stride(from: lowerMax, through: upperMin, by: step)).count
        for _ in 0..<100 {
            var containedValue = 0
            let lower = Int.random(in: min + step..<lowerMax)
            let upper = Int.random(in: upperMin..<max)
            for value in stride(from: min, through: max, by: step) {
                let clampedValue = value.clamped(to: lower...upper)

                XCTAssertGreaterThanOrEqual(clampedValue, lower)
                XCTAssertLessThanOrEqual(clampedValue, upper)

                if value == clampedValue {
                    containedValue += 1
                }
            }

            XCTAssertGreaterThanOrEqual(containedValue, minimumContained)
        }
    }
}
#endif
