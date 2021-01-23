//
//  KeyPathTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 1/22/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftExtensionsSpellBook
import XCTest

final class KeyPathTests: XCTestCase {
    struct Value {
        var i: Int
        var isEven: Bool {
            i.isMultiple(of: 2)
        }
    }

    let values: [Value] = (0..<10).map(Value.init(i:))

    func testPrefixOperatorBang() {
        XCTAssertEqual(values.filter(!\.isEven).map(\.i), [1, 3, 5, 7, 9])
    }

    func testInfixOperatorEquals() {
        XCTAssertEqual(values.filter(\.i == 2).map(\.i), [2])
    }
}
#endif
