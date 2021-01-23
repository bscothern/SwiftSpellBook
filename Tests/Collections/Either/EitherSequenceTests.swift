//
//  EitherSequenceTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class EitherSequenceTests: XCTestCase {
    func testEitherSequence2() {
        let e = Either<[Int], Set<Int>>.left([1, 2, 3, 4, 5])

        for values in zip(e, [1, 2, 3, 4, 5]) {
            XCTAssertEqual(values.0, values.1)
        }
    }

    func testEitherSequence3() {
        let e = Either<[Int], Set<Int>>.right([1, 2, 3, 4, 5])
        XCTAssertEqual(Set(e), Set([1, 2, 3, 4, 5]))
    }
}
#endif
