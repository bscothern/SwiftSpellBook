//
//  ArrayBuilderTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/11/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS) && swift(>=5.4)
import SwiftResultBuildersSpellBook
import XCTest
import XCTestSpellBook

final class ArrayBuilderTests: XCTestCase {
    func builder(@ArrayBuilder<Int> arrayBuilder: () -> [Int]) -> [Int] {
        arrayBuilder()
    }

    func testBuildExpresion() {
        let value = #line
        let builtArray = builder {
            value
        }
        XCTAssertEqual(builtArray, [value])
    }

    func testManyBuildExpression() {
        let builtArray = builder {
            0
            1
            2
            3
            4
        }
        XCTAssertEqual(builtArray, [0, 1, 2, 3, 4])
    }

    func testOptional() {
        let _false = false
        let builtArray = builder {
            if true {
                0
            }

            if _false {
                0xBADF00D
            }
        }
        XCTAssertEqual(builtArray, [0])
    }

    func testBuildEitherFirst() {
        var _trueFirstAccess = true
        var trueFirstAccess: Bool {
            defer { _trueFirstAccess = false }
            return _trueFirstAccess
        }

        let builtArray = builder {
            0

            if trueFirstAccess {
                42
            } else if trueFirstAccess {
                0xBADF00D
            }
        }
        XCTAssertEqual(builtArray, [0, 42])
    }

    func testBuildEitherSecond() {
        var _trueFirstAccess = false
        var trueFirstAccess: Bool {
            defer { _trueFirstAccess = true }
            return _trueFirstAccess
        }

        let builtArray = builder {
            0

            if trueFirstAccess {
                0xBADF00D
            } else if trueFirstAccess {
                42
            }
        }
        XCTAssertEqual(builtArray, [0, 42])
    }

    func testBuildArray() {
        let builtArray = builder {
            for i in 0..<5 {
                i
            }
        }
        XCTAssertEqual(builtArray, [0, 1, 2, 3, 4])
    }

    func testBuildLimitedAvailability() {
        let builtArray = builder {
            0

            if #available(macOS 99, iOS 99, tvOS 99, *) {
                0xBADF00D
            } else if #available(macOS 11, iOS 14, tvOS 14, *) {
                42
            } else {
                0xF00D
            }
        }

        let expected: [Int]
        if #available(macOS 11, iOS 14, tvOS 14, *) {
            expected = [0, 42]
        } else {
            expected = [0, 0xF00D]
        }

        XCTAssertEqual(builtArray, expected)
    }
}
#endif
