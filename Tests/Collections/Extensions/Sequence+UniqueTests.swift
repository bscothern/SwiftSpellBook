//
//  Seqeunce+UniqueTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/14/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftCollectionsSpellBook
import XCTest

final class SeqeunceUniqueTests: XCTestCase {
    class Foo: Hashable {
        var i: Int

        init() {
            i = Int.random(in: 0..<3)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(i)
        }

        static func == (lhs: Foo, rhs: Foo) -> Bool {
            lhs.i == rhs.i
        }
    }

    func testUniqueElements() {
        // Because Foo.i must be in the range 0..<3 this must have a duplicate Foo
        let original: [Foo] = [
            .init(),
            .init(),
            .init(),
            .init(),
        ]

        let unique = original.uniqueElements()

        let uniqueArray: [Foo] = Array(unique)
        XCTAssertLessThan(uniqueArray.count, original.count)

        for currentIndex in uniqueArray.indices {
            for index in uniqueArray[currentIndex...].indices where currentIndex != index {
                XCTAssertNotEqual(uniqueArray[currentIndex], uniqueArray[index])
            }
        }
    }

    func testUniqueElementsByID() {
        guard #available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *) else { return }
        // Because Foo.i must be in the range 0..<3 this must have a duplicate Foo
        let original: [Foo] = [
            .init(),
            .init(),
            .init(),
            .init(),
        ]

        let unique = original.uniqueElementsByID()

        let uniqueArray: [Foo] = Array(unique)
        XCTAssertLessThan(uniqueArray.count, original.count)

        for currentIndex in uniqueArray.indices {
            for index in uniqueArray[currentIndex...].indices where currentIndex != index {
                XCTAssertNotEqual(uniqueArray[currentIndex], uniqueArray[index])
            }
        }
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
extension SeqeunceUniqueTests.Foo: Identifiable {
    var id: Int { i }
}

#endif
