//
//  Zip3Tests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class Zip3Tests: XCTestCase {
    func testZip3() {
        let a1 = [1, 2, 3, 4, 5]
        let a2 = ["A", "B", "C", "D"]
        let a3 = [true, false, false, true, true, false]

        let iterator = zip(a1, a2, a3).makeIterator()
        XCTAssert(iterator.next().map { $0 == (1, "A", true) } ?? false)
        XCTAssert(iterator.next().map { $0 == (2, "B", false) } ?? false)
        XCTAssert(iterator.next().map { $0 == (3, "C", false) } ?? false)
        XCTAssert(iterator.next().map { $0 == (4, "D", true) } ?? false)
        XCTAssert(iterator.next().map { _ in false } ?? true)
    }
}
#endif
