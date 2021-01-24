//
//  _FromReferenceWritableKeyPathTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 12/12/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftPropertyWrappersSpellBook
import XCTest

final class _FromReferenceWritableKeyPathTests: XCTestCase {
    struct Foo {
        var i: Int = 0
    }
    
    final class Bar {
        @_FromReferenceWritableKeyPath(\Bar.foo.i)
        var i

        private var foo = Foo()
    }
    
    func testMutating() {
        let bar = Bar()
        
        XCTAssertEqual(bar.i, 0)
        
        bar.i = 1
        XCTAssertEqual(bar.i, 1)
        
        bar.i += 1
        XCTAssertEqual(bar.i, 2)
    }
}
#endif
