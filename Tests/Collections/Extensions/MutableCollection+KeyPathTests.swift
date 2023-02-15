//
//  MutableCollection+KeyPathTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 6/30/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class MutableCollectionKeyPathTests: XCTestCase {
    struct Foo: Equatable {
        var i: Int
    }

    func testSortComparableKeyPath() {
        var foos: [Foo] = []
        for i in 0..<10 {
            foos.append(Foo(i: i))
        }
        let originalFoos = foos
        foos.shuffle()
        XCTAssertNotEqual(originalFoos, foos)

        foos.sort(keyPath: \.i)

        XCTAssertEqual(originalFoos, foos)
    }

    func testAssingKeyPath() {
        var foos: [Foo] = []
        for i in 0..<10 {
            foos.append(Foo(i: i))
        }
        foos.assign(10, to: \.i)

        for foo in foos {
            XCTAssertEqual(Foo(i: 10), foo)
        }
    }
}
#endif
