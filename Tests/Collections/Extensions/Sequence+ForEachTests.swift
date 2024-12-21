//
//  Sequence+ForEachTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 6/30/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class SequenceForEachTests: XCTestCase {
    struct Foo {
        nonisolated(unsafe) static var count = 0

        func updateCount() {
            Self.count += 1
        }

        func a() -> Int {
            1
        }
    }

    func testSequenceForEach() {
        let count = 100
        let sequence = Array(repeating: Foo(), count: count)
        XCTAssertEqual(Foo.count, 0)
        sequence.forEachExecute(Foo.updateCount)
        XCTAssertEqual(Foo.count, count)
    }
}
#endif
