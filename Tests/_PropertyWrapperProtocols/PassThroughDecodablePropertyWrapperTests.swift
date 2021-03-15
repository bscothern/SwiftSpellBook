//
//  PassThroughDecodablePropertyWrapperTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import _PropertyWrapperProtocols
import XCTest

final class PassThroughDecodablePropertyWrapperTests: XCTestCase {
    @propertyWrapper
    struct TestPropertyWrapper<WrappedValue>: PassThroughDecodablePropertyWrapper where WrappedValue: Decodable {
        var wrappedValue: WrappedValue
    }
    
    func testPassThroughDecodablePropertyWrapper() throws {
        let value = #function
        let data = try JSONEncoder().encode(value)
        let result = try JSONDecoder().decode(TestPropertyWrapper<String>.self, from: data)
        XCTAssertEqual(result.wrappedValue, #function)
    }
}
#endif
