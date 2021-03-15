//
//  PassThroughHashablePropertyWrapperTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 3/13/21.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import _PropertyWrapperProtocols
import LoftTest_CheckXCAssertionFailure
import LoftTest_StandardLibraryProtocolChecks
import XCTest

final class PassThroughHashablePropertyWrapperTests: CheckXCAssertionFailureTestCase {
    @propertyWrapper
    struct TestPropertyWrapper<WrappedValue>: PassThroughHashablePropertyWrapper where WrappedValue: Hashable {
        var wrappedValue: WrappedValue
    }
    
    func testEqualPassThroughComparablePropertyWrapper() throws {
        let value1 = TestPropertyWrapper(wrappedValue: 1)
        let value2 = TestPropertyWrapper(wrappedValue: 1)
        let value3 = TestPropertyWrapper(wrappedValue: 2)
        let value4 = TestPropertyWrapper(wrappedValue: 3)
        
        value1.checkHashableLaws()
        value1.checkHashableLaws(equal: value2)
        
        checkXCAssertionFailure(
            value2.checkHashableLaws(equal: value3)
        )

        checkXCAssertionFailure(
            value3.checkHashableLaws(equal: value4)
        )

        checkXCAssertionFailure(
            value4.checkHashableLaws(equal: value1)
        )
    }
}
#endif
