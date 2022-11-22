//
//  SingleLinkedListPublicTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_StandardLibraryProtocolChecks
import SwiftCollectionsSpellBook
import XCTest

final class SingleLinkedListPublicTests: XCTestCase {
    typealias List<T> = SingleLinkedList<T>

    func testInit() {
        let list = List<Int>()
        list.checkCollectionLaws(expecting: [])
        list.checkHashableLaws()
    }

    func testAppendMany() {
        var list = List<Int>()
        let count = 100_000
        for i in 0..<count {
            list.append(i)
        }
        list.checkHashableLaws()
        XCTAssertEqual(list.count, count)
        zip(list, 0..<count).forEach {
            XCTAssertEqual($0, $1)
        }
    }

    func testPrependMany() {
        var list = List<Int>()
        let count = 100_000
        for i in 0..<count {
            list.prepend(i)
        }
        list.checkHashableLaws()
        XCTAssertEqual(list.count, count)
        zip(list, (0..<count).reversed()).forEach {
            XCTAssertEqual($0, $1)
        }
    }

    func testListReversed() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.prepend(i)
        }

        list.checkCollectionLaws(expecting: (0..<count).reversed())
        list.checkHashableLaws()
    }

    func testFullSlice() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        list[...].checkCollectionLaws(expecting: 0..<count)
    }

    func testSlice1() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        list[1...5].checkCollectionLaws(expecting: 1...5)
    }

    func testSlice2() {
        var list = List<Int>()
        let count = 5
        for i in 0..<count {
            list.append(i)
        }
        list[1..<4].checkCollectionLaws(expecting: 1..<4)
    }

    func testSlice3() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        list[...8].checkCollectionLaws(expecting: 0...8)
    }

    func testSlice4() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        list[..<8].checkCollectionLaws(expecting: 0..<8)
    }

    func testSlice5() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        list[2...].checkCollectionLaws(expecting: 2..<count)
    }

    func testIndexStartingWithOffset() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        let index: List<Int>.Index = 3
        XCTAssertEqual(list[index], 3)
    }

    func testEqual() {
        let list1: List<Int> = [1, 2, 3]
        let list2: List<Int> = [1, 2, 3]

        XCTAssertEqual(list1, list2)
    }

    func testNotEqual() {
        let list1: List<Int> = [1, 2, 3]
        let list2: List<Int> = [1, 3, 1]

        XCTAssertNotEqual(list1, list2)
    }

    func testIdentityEqual() {
        let list1: List<Int> = [1, 2, 3]
        let list2 = list1

        XCTAssertEqual(list1, list2)
    }
}
#endif
