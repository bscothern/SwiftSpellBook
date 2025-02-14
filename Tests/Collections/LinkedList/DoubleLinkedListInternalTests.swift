//
//  DoubleLinkedListInternalTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
@testable
import SwiftCollectionsSpellBook
import XCTest

final class DoubleLinkedListInternalTests: XCTestCase {
    typealias List<T> = DoubleLinkedList<T>

    func testCopy() {
        let list1: List<Int> = [1, 2, 3]
        var list2 = list1
        list2.append(4)

        zip(list1, list2).forEach {
            XCTAssertEqual($0, $1)
        }
        XCTAssertNotEqual(list1, list2)
        XCTAssertEqual(list1.count, 3)
        XCTAssertEqual(list2.count, 4)
    }

    func testCopyEmpty() {
        let list1 = List<Int>()
        var list2 = list1

        list2.append(1)
        XCTAssertNotEqual(list1, list2)
        XCTAssert(list1.isEmpty)
        XCTAssertEqual(list2.count, 1)
    }
}
#endif
