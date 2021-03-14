//
//  EitherBidirectionalCollectionTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/2/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_StandardLibraryProtocolChecks
import SwiftCollectionsSpellBook
import XCTest

final class EitherBidirectionalCollectionTests: XCTestCase {
    func testLeftBidirectionalCollectionConformance() {
        Either<[Int], [Int]>
            .left([1, 2, 3, 4, 5])
            .checkBidirectionalCollectionLaws(expecting: [1, 2, 3, 4, 5])
    }

    func testRightBidirectionalCollectionConformance() {
        Either<[Int], [Int]>
            .right([6, 7, 8, 9, 0])
            .checkBidirectionalCollectionLaws(expecting: [6, 7, 8, 9, 0])
    }

    func testEmptyLeftBidirectionalCollectionConformance() {
        Either<[Int], [Int]>
            .left([])
            .checkBidirectionalCollectionLaws(expecting: [])
    }

    func testEmptyRightBidirectionalCollectionConformance() {
        Either<[Int], [Int]>
            .right([])
            .checkBidirectionalCollectionLaws(expecting: [])
    }
}
#endif
