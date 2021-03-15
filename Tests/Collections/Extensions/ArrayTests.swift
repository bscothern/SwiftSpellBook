//
//  ArrayTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/14/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class ArrayTests: XCTestCase {
    func testInitMinimumCapacity() {
        let defaultCapacity = [Int]().capacity
        let minimumCapacity = Int.random(in: (defaultCapacity * 2)...(defaultCapacity * 3))
        var array = Array<Int>(minimumCapacity: minimumCapacity)
        let capacity = array.capacity
        XCTAssertGreaterThan(capacity, minimumCapacity)
        
        for _ in 0..<capacity {
            array.append(0)
        }
        XCTAssertEqual(array.capacity, capacity)
        array.append(0)
        XCTAssertGreaterThan(array.capacity, capacity)
    }
}
#endif
