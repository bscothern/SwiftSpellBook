//
//  IdentifiableBoxTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import LoftTest_CheckXCAssertionFailure
import LoftTest_StandardLibraryProtocolChecks
import SwiftBoxesSpellBook
import XCTest

final class IdentifiableBoxTests: CheckXCAssertionFailureTestCase {
    typealias FooBox = IdentifiableBox<Foo, Int>
    typealias BarBox = IdentifiableBox<Bar, Int>

    struct Foo {
        var s: String
    }

    class Bar {
        var s: String

        init(s: String) {
            self.s = s
        }
    }

    func testInitLazyIDWithStruct() {
        var canCallID = false
        var id: Int {
            if !canCallID {
                XCTFail("This should be lazy be called")
            }
            return 42
        }

        let box = FooBox(Foo(s: #function), id: id)
        XCTAssertEqual(box.s, #function)
        canCallID.toggle()
        XCTAssertEqual(box.id, 42)
    }

    func testSetValueWithStruct() {
        let id = #line
        var box = FooBox(Foo(s: #function), id: id)
        box.s = #fileID
        XCTAssertEqual(box.s, #fileID)
        XCTAssertEqual(box.id, id)
    }

    func testModifyValueWithStruct() {
        let id = #line
        var box = FooBox(Foo(s: #function), id: id)
        box.s += #function
        XCTAssertEqual(box.s, "\(#function)\(#function)")
        XCTAssertEqual(box.id, id)
    }

    func testKeyPathWithStruct() {
        let id = #line
        let box = FooBox(Foo(s: #function), id: id)
        func keyPathTest(_ keyPath: KeyPath<Foo, String>) -> String {
            box[dynamicMember: keyPath]
        }

        XCTAssertEqual(box.s, keyPathTest(\.s))
        XCTAssertEqual(box.id, id)
    }

    func testInitLazyIDWithClass() {
        var canCallID = false
        var id: Int {
            if !canCallID {
                XCTFail("This should be lazy be called")
            }
            return 42
        }

        let box = BarBox(Bar(s: #function), id: id)
        XCTAssertEqual(box.s, #function)
        canCallID.toggle()
        XCTAssertEqual(box.id, 42)
    }

    func testSetValueWithClass() {
        let id = #line
        let box = BarBox(Bar(s: #function), id: id)
        box.s = #fileID
        XCTAssertEqual(box.s, #fileID)
        XCTAssertEqual(box.id, id)
    }

    func testModifyValueWithClass() {
        let id = #line
        let box = BarBox(Bar(s: #function), id: id)
        box.s += #function
        XCTAssertEqual(box.s, "\(#function)\(#function)")
        XCTAssertEqual(box.id, id)
    }

    func testKeyPathWithClass() {
        let id = #line
        let box = BarBox(Bar(s: #function), id: id)
        func keyPathTest(_ keyPath: KeyPath<Bar, String>) -> String {
            box[dynamicMember: keyPath]
        }

        XCTAssertEqual(box.s, keyPathTest(\.s))
        XCTAssertEqual(box.id, id)
    }
}
#endif
