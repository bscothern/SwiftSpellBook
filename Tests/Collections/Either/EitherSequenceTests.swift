//
//  EitherSequenceTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_StandardLibraryProtocolChecks
import SwiftCollectionsSpellBook
import XCTest

final class EitherSequenceTests: XCTestCase {
    func testLeftSequenceConformance() {
        Either<[Int], Set<Int>>
            .left([1, 2, 3, 4, 5])
            .checkSequenceLaws(expecting: [1, 2, 3, 4, 5])
    }

    func testRightSequenceConformance() {
        Either<Set<Int>, [Int]>
            .right([6, 7, 8, 9, 0])
            .checkSequenceLaws(expecting: [6, 7, 8, 9, 0])
    }

    func testEmptyLeftSequenceConformance() {
        Either<[Int], [Int]>
            .left([])
            .checkSequenceLaws(expecting: [])
    }

    func testEmptyRightSequenceConformance() {
        Either<[Int], [Int]>
            .right([])
            .checkSequenceLaws(expecting: [])
    }
}
#endif
