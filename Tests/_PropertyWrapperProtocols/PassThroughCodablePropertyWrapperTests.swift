//
//  PassThroughCodablePropertyWrapperTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import _PropertyWrapperProtocols
import XCTest

final class PassThroughCodablePropertyWrapperTests: XCTestCase {
    @propertyWrapper
    struct TestPropertyWrapper<WrappedValue>: PassThroughCodablePropertyWrapper where WrappedValue: Codable {
        var wrappedValue: WrappedValue
    }

    func testPassThroughCodablePropertyWrapper() throws {
        let original = TestPropertyWrapper(wrappedValue: #function)
        let data = try JSONEncoder().encode(original)
        let value = try JSONDecoder().decode(String.self, from: data)
        XCTAssertEqual(value, #function)
        let copy = try JSONDecoder().decode(TestPropertyWrapper<String>.self, from: data)
        XCTAssertEqual(copy.wrappedValue, original.wrappedValue)
    }
}
#endif
