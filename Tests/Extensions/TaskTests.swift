//
//  TaskTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 7/5/22.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if swift(>=5.5) && canImport(Foundation) && !os(watchOS)
import SwiftExtensionsSpellBook
import XCTest

final class TaskTests: XCTestCase {
    func testWaitUntilFinished1() {
        @Sendable func foo() async -> Int {
            #file.count
        }
        
        let value = Task {
            await foo()
        }.waitUntilFinished()
        
        XCTAssertEqual(value, #file.count)
    }
    
    func testWaitUntilFinished2() throws {
        @Sendable func foo() async throws -> Int {
            #file.count
        }
        
        let value = try Task {
            try await foo()
        }.waitUntilFinished()
        
        XCTAssertEqual(value, #file.count)
    }

    func testWaitUntilFinished3() throws {
        @Sendable func foo() async throws -> Int {
            #file.count
        }
        
        let value: Result = Task {
            try await foo()
        }.waitUntilFinished()
        
        
        switch value {
        case let .success(value):
            XCTAssertEqual(value, #file.count)
        case .failure:
            XCTFail("Unexpected task failure")
        }
    }
}
#endif
