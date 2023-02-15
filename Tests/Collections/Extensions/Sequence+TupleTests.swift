//
//  Seqeunce+TuplesTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/14/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class SeqeunceTuplesTests: XCTestCase {
    final class Foo {
        var a: Int = 0
        var b: Int = 1
        var c: Int = 2
        var d: Int = 3
        init() {}
    }

    func testMap2() throws {
        let foo = Foo()
        let sequence = [foo].map(\.a, \.b)

        let value = try XCTUnwrap(sequence.first)
        XCTAssertEqual(value.0, 0)
        XCTAssertEqual(value.1, 1)
    }

    func testMap3() throws {
        let foo = Foo()
        let sequence = [foo].map(\.a, \.b, \.c)

        let value = try XCTUnwrap(sequence.first)
        XCTAssertEqual(value.0, 0)
        XCTAssertEqual(value.1, 1)
        XCTAssertEqual(value.2, 2)
    }

    func testMap4() throws {
        let foo = Foo()
        let sequence = [foo].map(\.a, \.b, \.c, \.d)

        let value = try XCTUnwrap(sequence.first)
        XCTAssertEqual(value.0, 0)
        XCTAssertEqual(value.1, 1)
        XCTAssertEqual(value.2, 2)
        XCTAssertEqual(value.3, 3)
    }
}
#endif
