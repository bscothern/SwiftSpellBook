//
//  Zip4Tests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class Zip4Tests: XCTestCase {
    func testZip4() {
        let a1 = [1, 2, 3, 4, 5]
        let a2 = ["A", "B", "C", "D"]
        let a3 = [true, false, false, true, true, false]
        let s1 = 10...

        let iterator = zip(a1, a2, a3, s1).makeIterator()
        XCTAssert(iterator.next().map { $0 == (1, "A", true, 10) } ?? false)
        XCTAssert(iterator.next().map { $0 == (2, "B", false, 11) } ?? false)
        XCTAssert(iterator.next().map { $0 == (3, "C", false, 12) } ?? false)
        XCTAssert(iterator.next().map { $0 == (4, "D", true, 13) } ?? false)
        XCTAssert(iterator.next().map { _ in false } ?? true)
    }
}
#endif
