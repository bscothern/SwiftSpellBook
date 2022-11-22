//
//  _FromKeyPathTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/3/21.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS) && PROPERTYWRAPPER_FROM_KEY_PATH
import SwiftPropertyWrappersSpellBook
import XCTest

final class _FromKeyPathTests: XCTestCase {
    struct Foo {
        var i: Int = 42
    }

    final class Bar {
        @_FromKeyPath(\Bar.foo.i)
        var i

        private var foo = Foo()
    }

    func testReadStructFromClass() {
        let bar = Bar()
        XCTAssertEqual(bar.i, 42)
    }
}
#endif
