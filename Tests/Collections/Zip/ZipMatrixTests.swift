//
//  ZipMatrixTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/14/23.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_StandardLibraryProtocolChecks
import SwiftCollectionsSpellBook
import XCTest

final class ZipMatrixTests: XCTestCase {
    let row = [1, 2, 3]
    let column = [1, 2, 3]
    let expectedValues: [(Int, Int)] = [
        (1, 1),
        (1, 2),
        (1, 3),
        (2, 1),
        (2, 2),
        (2, 3),
        (3, 1),
        (3, 2),
        (3, 3),
    ]

    func testSequenceLaws() {
        let zip = ZipMatrix(row: row, column: column)
        zip.checkSequenceLaws(expecting: expectedValues, areEquivalent: ==)
    }

    func testCollectionLaws() {
        let zip = ZipMatrix(row: row, column: column)
        zip.checkCollectionLaws(expecting: expectedValues, areEquivalent: ==)
    }

    func testNotBidirectionCollection() {
        XCTAssertFalse(ZipMatrix<Array<Int>, Array<Int>>.self is any BidirectionalCollection.Type, "ZipMatrix now conforms to BidirectionCollection and must be updated to match the new requirements.")
    }
}
#endif
