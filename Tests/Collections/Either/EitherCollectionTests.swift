//
//  EitherCollectionTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_StandardLibraryProtocolChecks
import SwiftCollectionsSpellBook
import XCTest

final class EitherCollectionTests: XCTestCase {
    func testLeftCollectionConformance() {
        Either<[Int], [Int]>
            .left([1, 2, 3, 4, 5])
            .checkCollectionLaws(expecting: [1, 2, 3, 4, 5])
    }

    func testRightCollectionConformance() {
        Either<[Int], [Int]>
            .right([6, 7, 8, 9, 0])
            .checkCollectionLaws(expecting: [6, 7, 8, 9, 0])
    }

    func testEmptyLeftCollectionConformance() {
        Either<[Int], [Int]>
            .left([])
            .checkCollectionLaws(expecting: [])
    }

    func testEmptyRightCollectionConformance() {
        Either<[Int], [Int]>
            .right([])
            .checkCollectionLaws(expecting: [])
    }
}
#endif
