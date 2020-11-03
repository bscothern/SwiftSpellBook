//
//  EitherCollectionTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

import ProtocolTests
import SwiftCollectionsSpellBook
import XCTest

final class EitherCollectionTests: XCTestCase, CollectionTests {
    typealias CollectionType = Either<[Int], Set<Int>>
    typealias Element = Int
    
    static var mode: Mode = .left
    
    enum Mode {
        case left
        case right
    }
    
    func testRunCollectionTestsLeft() throws {
        Self.mode = .left
        try runCollectionTests()
    }
    
    func testRunCollectionTestsRight() throws {
        Self.mode = .right
        try runCollectionTests()
    }
    
    func protocolTestSuiteEmptyCollection() -> CollectionType? {
        switch Self.mode {
        case .left:
            return .left([])
        case .right:
            return .right([])
        }
    }

    func protocolTestSuitePopulatedCollection() -> CollectionType? {
        switch Self.mode {
        case .left:
            return .left([1, 2, 3, 4, 5])
        case .right:
            return .right([6, 7, 8, 9, 0])
        }
    }
}
