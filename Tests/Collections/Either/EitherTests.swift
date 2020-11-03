//
//  EitherTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 10/30/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import SwiftCollectionsSpellBook
import XCTest

final class EitherTests: XCTestCase {
    func testFactoryInitLeft() {
        let e = Either.left(42, or: String.self)
        XCTAssertEqual(e.left, 42)
        XCTAssertNil(e.right)
    }
    
    func testFactoryInitRight() {
        let e = Either.right(42, or: String.self)
        XCTAssertEqual(e.right, 42)
        XCTAssertNil(e.left)
    }
    
    func testFatoryInitLeftImpliedRight() {
        let e: Either<Int, String> = .left(42)
        XCTAssertEqual(e.left, 42)
        XCTAssertNil(e.right)
    }
    
    func testFatoryInitRightImpliedLeft() {
        let e: Either<String, Int> = .right(42)
        XCTAssertEqual(e.right, 42)
        XCTAssertNil(e.left)
    }
    
    func testEquatable() {
        var values: [Either<Int, String>] = []
        for i in 0..<100 {
            values.append(i.isMultiple(of: 2) ? .left(i) : .right("\(i)"))
        }
        
        let shuffled = values.shuffled()

        XCTAssertEqual(Set(values), Set(shuffled))
    }
    
    func testEquatable2() {
        var values1: [Either<Int, String>] = []
        var values2: [Either<Int, String>] = []
        for i in 0..<100 {
            values1.append(i.isMultiple(of: 2) ? .left(i) : .right("\(i)"))
            values2.append(i.isMultiple(of: 2) ? .right("\(i)") : .left(i))
        }

        let set1 = Set(values1)
        let set2 = Set(values2)
        
        XCTAssertNotEqual(set1, set2)
        XCTAssertTrue(set1.intersection(set2).isEmpty)
        XCTAssertEqual(set1.union(set2).count, 200)
    }
    
    func testComparable1() {
        let l = Either<Int, String>.left(1)
        let r = Either<Int, String>.left(2)
        
        XCTAssertLessThan(l, r)
        XCTAssertGreaterThan(r, l)
        XCTAssertNotEqual(l, r)
    }
    
    func testComparable2() {
        let l = Either<Int, String>.right("1")
        let r = Either<Int, String>.right("2")
        
        XCTAssertLessThan(l, r)
        XCTAssertGreaterThan(r, l)
        XCTAssertNotEqual(l, r)
    }
    
    func testComparable3() {
        let l = Either<Int, String>.left(1)
        let r = Either<Int, String>.right("2")
        
        XCTAssertLessThan(l, r)
        XCTAssertGreaterThan(r, l)
        XCTAssertNotEqual(l, r)
    }

    func testComparable4() {
        let l = Either<Int, String>.right("1")
        let r = Either<Int, String>.left(2)
        
        XCTAssertLessThan(r, l)
        XCTAssertGreaterThan(l, r)
        XCTAssertNotEqual(l, r)
    }
}
