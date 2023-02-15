//
//  NSLockingClosuresTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import Foundation
import SwiftConcurrencySpellBook
import XCTest

final class NSLockingClosuresTests: XCTestCase {
    func testProtect() {
        let lock = NSLock()
        var value = 0
        let iterations = 1000

        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            lock.protect { value += 1 }
        }

        XCTAssertEqual(value, iterations)
    }

    func testTryProtect() {
        let throwingLock = NSLock()
        var throwCount = 0
        let catchLock = NSLock()
        var catchCount = 0
        let iterations = 1000
        struct TestError: Error {}

        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            do {
                try throwingLock.protect {
                    throwCount += 1
                    throw TestError()
                }
                XCTFail("Shouldn't be called")
            } catch {
                catchLock.protect {
                    catchCount += 1
                }
            }
        }

        XCTAssertEqual(throwCount, iterations)
        XCTAssertEqual(catchCount, iterations)
    }
}
#endif
