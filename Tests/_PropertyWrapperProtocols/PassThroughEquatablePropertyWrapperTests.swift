//
//  PassThroughEquatablePropertyWrapper.swift
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

final class PassThroughEquatablePropertyWrapperTests: CheckXCAssertionFailureTestCase {
    @propertyWrapper
    struct TestPropertyWrapper<WrappedValue>: PassThroughEquatablePropertyWrapper where WrappedValue: Equatable {
        var wrappedValue: WrappedValue
    }

    func testEqualPassThroughComparablePropertyWrapper() throws {
        let value1 = TestPropertyWrapper(wrappedValue: 1)
        let value2 = TestPropertyWrapper(wrappedValue: 1)
        let value3 = TestPropertyWrapper(wrappedValue: 2)
        let value4 = TestPropertyWrapper(wrappedValue: 3)

        value1.checkEquatableLaws()
        value1.checkEquatableLaws(equal: value2)

        checkXCAssertionFailure(
            value2.checkEquatableLaws(equal: value3)
        )

        checkXCAssertionFailure(
            value3.checkEquatableLaws(equal: value4)
        )

        checkXCAssertionFailure(
            value4.checkEquatableLaws(equal: value1)
        )
    }
}
#endif
