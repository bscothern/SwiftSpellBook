//
//  ResultTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/14/23.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
@testable import _Concurrency_ExtensionsSpellBook
import XCTest

final class ResultTests: XCTestCase {
    struct TestError: Error {}
    
    func value() async throws -> Int {
        1
    }
    
    func fail() async throws -> Int {
        throw TestError()
    }
    
    func testSuccess() async {
        let result = await Result {
            try await value()
        }
        switch result {
        case let .success(value):
            XCTAssertEqual(value, 1)
        case .failure:
            XCTFail("Expected success case")
        }
    }
    
    func testThrow() async {
        let result = await Result {
            try await fail()
        }
        switch result {
        case .success:
            XCTFail("Expected failure case")
        case .failure(_ as TestError):
            break
        case .failure:
            XCTFail("Unexpected failure value")
        }
    }
    
    func testDisfavoredOverload() async {
        let result = Result {
            1
        }
        switch result {
        case let .success(value):
            XCTAssertEqual(value, 1)
        case .failure:
            XCTFail("Expected success case")
        }
    }
}
#endif
