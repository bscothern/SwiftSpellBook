//
//  LazySequenceProtocol+TuplesTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/14/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class LazySequenceProtocolTuplesTests: XCTestCase {
    final class Foo {
        var fail = true

        private var _a: Int = 0
        var a: Int {
            checkFailure()
            return _a
        }
        private var _b: Int = 1
        var b: Int {
            checkFailure()
            return _b
        }
        private var _c: Int = 2
        var c: Int {
            checkFailure()
            return _c
        }
        private var _d: Int = 3
        var d: Int {
            checkFailure()
            return _d
        }

        init() {}

        func checkFailure() {
            if fail {
                XCTFail("map should be lazy")
            }
        }
    }

    func testMap2() throws {
        let foo = Foo()
        let sequence = [foo].lazy.map(\.a, \.b)

        foo.fail.toggle()
        let value = try XCTUnwrap(sequence.first)
        XCTAssertEqual(value.0, 0)
        XCTAssertEqual(value.1, 1)
    }

    func testMap3() throws {
        let foo = Foo()
        let sequence = [foo].lazy.map(\.a, \.b, \.c)

        foo.fail.toggle()
        let value = try XCTUnwrap(sequence.first)
        XCTAssertEqual(value.0, 0)
        XCTAssertEqual(value.1, 1)
        XCTAssertEqual(value.2, 2)
    }

    func testMap4() throws {
        let foo = Foo()
        let sequence = [foo].lazy.map(\.a, \.b, \.c, \.d)

        foo.fail.toggle()
        let value = try XCTUnwrap(sequence.first)
        XCTAssertEqual(value.0, 0)
        XCTAssertEqual(value.1, 1)
        XCTAssertEqual(value.2, 2)
        XCTAssertEqual(value.3, 3)
    }
}
#endif
