//
//  SwitchExpressionTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/11/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS) && swift(>=5.4)
import SwiftResultBuildersSpellBook
import XCTest
import XCTestSpellBook

final class SwitchExpressionTests: XCTestCase {
    func testSwitchExpression() {
        @SwitchExpression<Int>
        func value(for value: Character) -> Int {
            switch value {
            case "a":
                0
            case "b":
                1
            case "c":
                2
            default:
                3
            }
        }

        XCTAssertEqual(value(for: "a"), 0)
        XCTAssertEqual(value(for: "b"), 1)
        XCTAssertEqual(value(for: "c"), 2)
        XCTAssertEqual(value(for: "d"), 3)
    }
}
#endif
