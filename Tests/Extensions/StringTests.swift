//
//  StringTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 1/22/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftExtensionsSpellBook
import XCTest

final class StringTests: XCTestCase {
    func testStaticStringInitNullTerminated() {
        let staticString: StaticString = "Foo Bar Baz"
        let nonStaticString: String = "Foo Bar Baz"
        
        XCTAssertEqual(String(staticString), nonStaticString)
    }
    
    func testStaticStringInitSingleUnicodeScalar() {
        // Taken from StaticString documentation on 1/22/21
        struct MyStaticScalar: ExpressibleByUnicodeScalarLiteral {
            typealias UnicodeScalarLiteralType = StaticString
            let value: StaticString
            init(unicodeScalarLiteral value: StaticString) {
                self.value = value
            }
        }
        
        let staticEmoji: StaticString = MyStaticScalar("\u{1F600}").value
        let nonStaticEmoji: String = "\u{1F600}"
        
        XCTAssertEqual(String(staticEmoji), nonStaticEmoji)
    }
    
    func testEmptyStaticStringInit() {
        let staticString: StaticString = ""
        let nonStaticString: String = ""
        
        XCTAssertEqual(String(staticString), nonStaticString)
    }
}
#endif
