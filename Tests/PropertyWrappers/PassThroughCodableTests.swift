//
//  PassThroughCodableTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 11/2/20.
//  Copyright © 2020 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import Foundation
import SwiftPropertyWrappersSpellBook
import XCTest

final class PassThroughCodableTests: XCTestCase {
    func testEncodabe() throws {
        let value = AlwaysEqual<Int>(wrappedValue: 42)
        let data = try JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        XCTAssertEqual(string, "42")
    }

    func testDecodable() throws {
        let data = "42".data(using: .utf8)!
        let value = try JSONDecoder().decode(AlwaysEqual<Int>.self, from: data)
        XCTAssertEqual(value.wrappedValue, 42)
    }
}
#endif
