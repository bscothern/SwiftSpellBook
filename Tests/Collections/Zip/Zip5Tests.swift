//
//  Zip5Tests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/11/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class Zip5Tests: XCTestCase {
    func testZip5() {
        let a1 = [1, 2, 3, 4, 5]
        let a2 = ["A", "B", "C", "D"]
        let a3 = [true, false, false, true, true, false]
        let s1 = 10...
        let s2 = AnySequence<String> { () -> AnyIterator<String> in
            var c: Character = "E"
            return AnyIterator {
                defer {
                    c = Character(Unicode.Scalar(c.unicodeScalars.first!.value + 1)!)
                }
                return "Foo-\(c)"
            }
        }

        let iterator = zip(a1, a2, a3, s1, s2).makeIterator()
        XCTAssert(iterator.next().map { $0 == (1, "A", true, 10, "Foo-E") } ?? false)
        XCTAssert(iterator.next().map { $0 == (2, "B", false, 11, "Foo-F") } ?? false)
        XCTAssert(iterator.next().map { $0 == (3, "C", false, 12, "Foo-G") } ?? false)
        XCTAssert(iterator.next().map { $0 == (4, "D", true, 13, "Foo-H") } ?? false)
        XCTAssert(iterator.next().map { _ in false } ?? true)
    }
}
#endif
