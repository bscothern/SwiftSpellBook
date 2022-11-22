//
//  OSUnfairLockTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 2/25/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import _Concurrency_PropertyWrappersSpellBook
import XCTest

final class OSUnfairLockTests: XCTestCase {
    func testOSUnfairLock() {
        let lock = OSUnfairLock()

        lock.assertNotOwner()
        lock.lock()
        lock.assertOwner()
        lock.unlock()
        lock.assertNotOwner()
    }

    func testOSUnfairLockTry() {
        let lock = OSUnfairLock()
        let expectation = XCTestExpectation()

        DispatchQueue.global().async {
            lock.lock()
            expectation.fulfill()
            sleep(1)
            lock.unlock()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(lock.try())
    }
}
#endif
