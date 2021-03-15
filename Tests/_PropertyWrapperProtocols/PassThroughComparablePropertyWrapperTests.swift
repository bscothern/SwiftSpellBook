//
//  PassThroughComparablePropertyWrapperTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import _PropertyWrapperProtocols
import LoftTest_StandardLibraryProtocolChecks
import XCTest

final class PassThroughComparablePropertyWrapperTests: XCTestCase {
    @propertyWrapper
    struct TestPropertyWrapper<WrappedValue>: PassThroughComparablePropertyWrapper where WrappedValue: Comparable {
        var wrappedValue: WrappedValue
    }
    
    func testEqualPassThroughComparablePropertyWrapper() throws {
        let value1 = TestPropertyWrapper(wrappedValue: 1)
        let value2 = TestPropertyWrapper(wrappedValue: 1)
        let value3 = TestPropertyWrapper(wrappedValue: 2)
        let value4 = TestPropertyWrapper(wrappedValue: 3)
        
        value1.checkComparableLaws(equal: value2, greater: value3, greaterStill: value4)
    }
}
#endif
