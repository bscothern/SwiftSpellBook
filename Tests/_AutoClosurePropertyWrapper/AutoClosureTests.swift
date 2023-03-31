//
//  AutoClosureTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/7/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class AutoClosureTests: XCTestCase {
    func testInitWithClosure() {
        var isLazy = false
        let autoClosure: AutoClosure<Int> = .init {
            XCTAssert(isLazy)
            return 42
        }

        isLazy.toggle()
        XCTAssertEqual(autoClosure.wrappedValue, 42)
    }

    func testInitWithAutoClosure() {
        var isLazy = false
        let autoClosure: AutoClosure<Int> = .init(wrappedValue: { () -> Int in
            XCTAssert(isLazy)
            return 123
        }())

        isLazy.toggle()
        XCTAssertEqual(autoClosure.wrappedValue, 123)
    }

    func testProjectedValue() {
        let autoClosure: AutoClosure<Int> = .init(wrappedValue: 1)
        let projected = autoClosure.projectedValue

        XCTAssertEqual(autoClosure.wrappedValue, projected.wrappedValue)
    }
}
#endif
