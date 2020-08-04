//
//  SingleLinkedListPublicTests.swift
//  ThingsMissingFromSwiftTests
//
//  Created by Braden Scothern on 7/15/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ProtocolTests
import ThingsMissingFromSwiftCollections
import XCTest


final class SingleLinkedListPublicTests: XCTestCase, CollectionTests {
    typealias List<T> = SingleLinkedList<T>
    typealias CollectionType = List<Int>
    typealias Element = Int

    func testRunCollectionTests() throws {
        try runCollectionTests()
    }
    
    func protocolTestSuiteEmptyCollection() -> CollectionType? {
        CollectionType()
    }

    func protocolTestSuitePopulatedCollection() -> CollectionType? {
        [1, 2, 3, 4, 5]
    }

    func testInit() {
        let list = List<Int>()
        XCTAssert(list.isEmpty)
        XCTAssertEqual(list.startIndex, list.endIndex)
    }
    
    func testAppendMany() {
        var list = List<Int>()
        let count = 100_000
        for i in 0..<count {
            list.append(i)
        }
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
        
        zip(list.reversed(), 0..<count).forEach {
            XCTAssertEqual($0, $1)
        }
    }
    
    func testFullSlice() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        zip(list[...], 0...).forEach {
            XCTAssertEqual($0, $1)
        }
    }

    func testSlice1() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        zip(list[1...5], 1...5).forEach {
            XCTAssertEqual($0, $1)
        }
    }

    func testSlice2() {
        var list = List<Int>()
        let count = 5
        for i in 0..<count {
            list.append(i)
        }

        zip(list[1..<4], 1...).forEach {
            print("-------------")
            XCTAssertEqual($0, $1)
        }
    }

    func testSlice3() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        zip(list[...8], 0...).forEach {
            XCTAssertEqual($0, $1)
        }
    }

    func testSlice4() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        zip(list[..<8], 0...).forEach {
            XCTAssertEqual($0, $1)
        }
    }
    
    func testSlice5() {
        var list = List<Int>()
        let count = 10
        for i in 0..<count {
            list.append(i)
        }
        zip(list[2...], 2...).forEach {
            XCTAssertEqual($0, $1)
        }
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
