//
//  EitherMutableCollectionTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/2/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_StandardLibraryProtocolChecks
import SwiftCollectionsSpellBook
import XCTest

final class EitherMutableCollectionTests: XCTestCase {
    func testLeftMutableCollectionConformance() {
        var value = Either<[Int], [Int]>
            .left([1, 2, 3, 4, 5])
        value.checkMutableCollectionLaws(expecting: [1, 2, 3, 4, 5], writing: [6, 7, 8, 9, 10])
    }

    func testRightMutableCollectionConformance() {
        var value = Either<[Int], [Int]>
            .right([1, 2, 3, 4, 5])
        value.checkMutableCollectionLaws(expecting: [1, 2, 3, 4, 5], writing: [6, 7, 8, 9, 10])
    }

    func testEmptyLeftMutableCollectionConformance() {
        var value = Either<[Int], [Int]>
            .left([])
        value.checkMutableCollectionLaws(expecting: [], writing: [])
    }

    func testEmptyRightMutableCollectionConformance() {
        var value = Either<[Int], [Int]>
            .right([])
        value.checkMutableCollectionLaws(expecting: [], writing: [])
    }
}
#endif
