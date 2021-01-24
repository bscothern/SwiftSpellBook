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

    struct S2 {
        @Locked
        var c: COWCollection<Int> = []
    }

    struct COWCollection<Element>: MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral {
        final class Buffer {
            var values: [Element]

            init(values: [Element] = []) {
                self.values = values
            }
        }

        struct Index: Comparable {
            let value: Array<Element>.Index

            static func < (lhs: COWCollection<Element>.Index, rhs: COWCollection<Element>.Index) -> Bool {
                lhs.value < rhs.value
            }
        }

        var buffer: Buffer

        var startIndex: Index {
            .init(value: buffer.values.startIndex)
        }

        var endIndex: Index {
            .init(value: buffer.values.endIndex)
        }

        init(arrayLiteral elements: Element...) {
            buffer = .init(values: elements)
        }

        func index(after i: Index) -> Index {
            .init(value: buffer.values.index(after: i.value))
        }

        func index(before i: Index) -> Index {
            .init(value: buffer.values.index(before: i.value))
        }

        subscript(position: Index) -> Element {
            get { buffer.values[position.value] }
            set {
                if !isKnownUniquelyReferenced(&buffer) {
                    XCTFail("Buffer is referenced multiple times which would trigger copy on write")
                    buffer = .init(values: buffer.values)
                }
                buffer.values[position.value] = newValue
            }
        }

        @_transparent
        mutating func isUnique() -> Bool {
            isKnownUniquelyReferenced(&buffer)
        }
    }

    func runTest(lockType: Locked<Int>.LockType, file: StaticString = #file, line: UInt = #line) {
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

        // Make sure the default is to protect the lock
        let originalLock = value.$i.lock
        let newLock = Locked<Int>(wrappedValue: 0)

        value.$i = newLock
        XCTAssertEqual(value.i, 0)
        XCTAssert(value.$i.lock === originalLock)
    }

    func testDefaultInit() {
        let s = S(0)
        XCTAssertEqual(ObjectIdentifier(type(of: s.$i.lock)), ObjectIdentifier(type(of: Locked<Int>.LockType.platformDefault.createLock())))
    }

//    func testNSLock() {
//        runTest(lockType: .nsLock)
//    }
//
//    func testNSRecursiveLock() {
//        runTest(lockType: .nsRecursiveLock)
//    }
//
//    func testOSUnfairLock() {
//        if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
//            runTest(lockType: .osUnfairLock)
//        }
//    }

//    func testNoProjectedValueProtectsLock() {
//        var value = S(.init(wrappedValue: 0, projectedValueIsProtected: false))
//
//        let originalLock = value.$i.lock
//        let newLock = Locked<Int>(wrappedValue: 1)
//
//        value.$i = newLock
//        XCTAssertEqual(value.i, 1)
//        XCTAssert(value.$i.lock !== originalLock)
//        XCTAssert(value.$i.lock === newLock.lock)
//
//        let anotherNewLock = Locked<Int>(wrappedValue: 2)
//        value.$i = anotherNewLock
//        XCTAssertEqual(value.i, 2)
//        XCTAssert(value.$i.lock !== newLock.lock)
//        XCTAssert(value.$i.lock === anotherNewLock.lock)
//    }
//
//    func testNoCOW() {
//        var value = S2(c: [1, 2, 3])
//        value.$c.modify { value in
//            var index = value.startIndex
//            while index != value.endIndex {
//                value[index] *= 2
//                value.formIndex(after: &index)
//            }
//        }
//
//        XCTAssertEqual(value.c, [2, 4, 6])
//    }

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

extension LockedTests.COWCollection: Equatable where Element: Equatable {
    static func == (lhs: LockedTests.COWCollection<Element>, rhs: LockedTests.COWCollection<Element>) -> Bool {
        lhs.buffer.values == rhs.buffer.values
    }
}

#endif
