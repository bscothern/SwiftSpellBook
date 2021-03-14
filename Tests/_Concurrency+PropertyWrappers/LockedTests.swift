//
//  LockedTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/18/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS) && canImport(Foundation)
@testable import _Concurrency_PropertyWrappersSpellBook
import XCTest

final class LockedTests: XCTestCase {
    struct S {
        @Locked
        var i: Int

        init(_ i: Int) {
            self.init(.init(wrappedValue: i))
        }

        init(_ i: Locked<Int>) {
            self._i = i
        }
    }

    func runTest(lockType: Locked<Int>.LockType, file: StaticString = #file, line: UInt = #line) throws {
        var value = S(.init(wrappedValue: 0, lockType: lockType))

        let iterations = 1000
        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            value.i += 1
        }
        XCTAssertEqual(value.i, iterations, file: file, line: line)

        value.i = -1
        XCTAssertEqual(value.i, -1, file: file, line: line)

        value.$i.use { value in
            XCTAssertEqual(value, -1, file: file, line: line)
        }

        value.$i.modify { value in
            value = 42
        }
        XCTAssertEqual(value.i, 42, file: file, line: line)

        let newLocked = Locked<Int>(wrappedValue: 0)

        value.$i = newLocked
        XCTAssertEqual(value.i, newLocked.wrappedValue, file: file, line: line)
        XCTAssertEqual(value.i, 0, file: file, line: line)

        // Make sure try functions work
        let ranTryUse = try XCTUnwrap(
            value.$i.tryUse { value -> Bool in
                XCTAssertEqual(value, 0, file: file, line: line)
                return true
            }
        )
        XCTAssertTrue(ranTryUse, file: file, line: line)

        let ranTryModify = try XCTUnwrap(
            value.$i.tryModify { value -> Bool in
                value += 1
                XCTAssertEqual(value, 1, file: file, line: line)
                return true
            }
        )
        XCTAssertTrue(ranTryModify, file: file, line: line)

        // Test try functions when already aquired
        do {
            let waitExpecation = XCTestExpectation()
            let continueExpectation = XCTestExpectation()

            DispatchQueue.global().async {
                value.$i.use { _ in
                    waitExpecation.fulfill()
                    self.wait(for: [continueExpectation], timeout: 1.0)
                }
            }
            wait(for: [waitExpecation], timeout: 1.0)

            let gotLock: Void? = value.$i.tryUse { _ -> Void in
                XCTFail("Shouldn't be able to aquireLock", file: file, line: line)
            }
            continueExpectation.fulfill()
            XCTAssertNil(gotLock, file: file, line: line)
        }

        do {
            let waitExpecation = XCTestExpectation()
            let continueExpectation = XCTestExpectation()

            DispatchQueue.global().async {
                value.$i.modify { _ in
                    waitExpecation.fulfill()
                    self.wait(for: [continueExpectation], timeout: 1.0)
                }
            }
            wait(for: [waitExpecation], timeout: 1.0)

            let gotLock: Void? = value.$i.tryModify { _ -> Void in
                XCTFail("Shouldn't be able to aquireLock", file: file, line: line)
            }
            continueExpectation.fulfill()
            XCTAssertNil(gotLock, file: file, line: line)
        }
    }

    func testDefaultInit() {
        let s = S(0)
        XCTAssertEqual(ObjectIdentifier(type(of: s.$i.lock)), ObjectIdentifier(type(of: Locked<Int>.LockType.platformDefault.createLock())))
    }

    func testNSLock() throws {
        try runTest(lockType: .nsLock)
    }

    func testNSRecursiveLock() throws {
        try runTest(lockType: .nsRecursiveLock)
    }

    func testOSUnfairLock() throws {
        guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) else { return }
        try runTest(lockType: .osUnfairLock)
    }

    func testLockTypePlatformDefault() {
        let platformDefault = Locked<Any>.LockType.platformDefault
        if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
            XCTAssertEqual(platformDefault, .osUnfairLock)
        } else {
            XCTAssertEqual(platformDefault, .nsLock)
        }
    }

    func testLockTypeCreateLockType() {
        if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
            let lock = Locked<Any>.LockType.osUnfairLock.createLock()
            XCTAssertEqual(ObjectIdentifier(type(of: lock)), ObjectIdentifier(OSUnfairLock.self))
        }

        do {
            let lock = Locked<Any>.LockType.nsLock.createLock()
            XCTAssertEqual(ObjectIdentifier(type(of: lock)), ObjectIdentifier(NSLock.self))
        }

        do {
            let lock = Locked<Any>.LockType.nsRecursiveLock.createLock()
            XCTAssertEqual(ObjectIdentifier(type(of: lock)), ObjectIdentifier(NSRecursiveLock.self))
        }
    }
}

#endif
