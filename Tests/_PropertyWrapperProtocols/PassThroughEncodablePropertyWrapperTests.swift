//
//  PassThroughEncodablePropertyWrapperTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import _PropertyWrapperProtocols
import XCTest

final class PassThroughEncodablePropertyWrapperTests: XCTestCase {
    @propertyWrapper
    struct TestPropertyWrapper<WrappedValue>: PassThroughEncodablePropertyWrapper where WrappedValue: Codable {
        var wrappedValue: WrappedValue
    }

    func testPassThroughEncodablePropertyWrapper() throws {
        let value = TestPropertyWrapper(wrappedValue: #function)
        let data = try JSONEncoder().encode(value)
        let result = try JSONDecoder().decode(String.self, from: data)
        XCTAssertEqual(result, #function)
    }
}
#endif
