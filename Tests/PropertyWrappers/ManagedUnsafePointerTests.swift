//
//  ManagedUnsafePointerTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/12/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class ManagedUnsafePointerTests: XCTestCase {
    struct Value {
        @ManagedUnsafePointer
        var i: Int
    }

    struct DeinitValue {
        @ManagedUnsafePointer
        var c: DeinitClass
    }

    final class DeinitClass {
        let onDeinit: () -> Void

        init(onDeinit: @escaping () -> Void) {
            self.onDeinit = onDeinit
        }

        deinit {
            onDeinit()
        }
    }

    func testCanAssign() {
        func assign(value: Int, to pointer: UnsafeMutablePointer<Int>) {
            pointer.pointee = value
        }

        func read(pointer: UnsafePointer<Int>) -> Int {
            pointer.pointee
        }
        var value = Value(i: 1)

        XCTAssertEqual(value.i, 1)
        XCTAssertEqual(read(pointer: value.$i.unsafePointer), 1)

        let copy = value
        assign(value: 2, to: copy.$i.unsafeMutablePointer)

        XCTAssertEqual(value.i, copy.i)
        XCTAssertEqual(value.$i.unsafePointer, copy.$i.unsafePointer)
        XCTAssertEqual(value.$i.unsafeMutablePointer, copy.$i.unsafeMutablePointer)

        XCTAssertEqual(value.i, 2)
        XCTAssertEqual(read(pointer: value.$i.unsafePointer), 2)

        value.i = 3
        XCTAssertEqual(value.i, 3)

        value.i += 1
        XCTAssertEqual(value.i, 4)
    }

    func testCanCopyValue() {
        let value = Value(i: 1)
        let pointerCopy = value.$i.copy(\.pointee)

        XCTAssertEqual(value.i, pointerCopy.wrappedValue)
        XCTAssertNotEqual(value.$i.unsafePointer, pointerCopy.unsafePointer)
    }

    func testCanCopyClass() {
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 2

        var address1: Int?
        var address2: Int?

        DispatchQueue.global().async {
            let value0 = DeinitValue(c: .init(onDeinit: {
                expectation.fulfill()
            }))

            let value1 = value0.$c.copy { pointer in
                .init(onDeinit: pointer.pointee.onDeinit)
            }

            address1 = Int(bitPattern: value0.$c.unsafePointer)
            address2 = Int(bitPattern: value1.unsafePointer)
        }

        wait(for: [expectation], timeout: 2.0)
        XCTAssertNotNil(address1)
        XCTAssertNotNil(address2)
        XCTAssertNotEqual(address1, address2)
    }

    func testMemoryIsCleanedUp() {
        let expectation = XCTestExpectation()
        DispatchQueue.global().async {
            let deinitClass = DeinitClass {
                expectation.fulfill()
            }

            let value = DeinitValue(c: deinitClass)

            XCTAssertTrue(deinitClass === value.c)
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
#endif
