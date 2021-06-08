//
//  XCAssertThrownErrorIsExpected.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 12/15/20.
//  Copyright © 2020-2021 Braden Scothern. All rights reserved.
//

#if canImport(XCTest) && !os(watchOS)
import SwiftResultBuildersSpellBook
import XCTest

@inlinable
public func XCAssertThrownErrorIsExpected<ExpectedError, T>(
    _ expression: @autoclosure () throws -> T,
    expects expectedError: ExpectedError,
    _ message: @autoclosure () -> String = "Didn't throw expected error",
    file: StaticString = #file,
    line: UInt = #line,
    errorHandler: (Error) -> Void = { _ in }
) where ExpectedError: Equatable {
    XCAssertThrownErrorIsExpected(
        try expression(),
        errorComparator: { (error: ExpectedError) in
            error == expectedError
        },
        message(),
        file: file,
        line: line,
        errorHandler: errorHandler
    )
}

@usableFromInline
@inline(__always)
func _XCAssertThrownErrorIsExpected<ExpectedError, T>(
    _ expression: () throws -> T,
    errorComparator: (ExpectedError) -> Bool,
    _ message: () -> String,
    file: StaticString,
    line: UInt,
    errorHandler: (Error) -> Void
) {
    XCTAssertThrowsError(try expression(), message(), file: file, line: line) { error in
        errorHandler(error)
        guard let expectedError = error as? ExpectedError else {
            XCTFail(message(), file: file, line: line)
            return
        }
        XCTAssert(errorComparator(expectedError), message(), file: file, line: line)
    }
}

#if swift(>=5.4)
@inlinable
public func XCAssertThrownErrorIsExpected<ExpectedError, T>(
    _ expression: @autoclosure () throws -> T,
    @SwitchExpression<Bool> errorComparator: (ExpectedError) -> Bool,
    _ message: @autoclosure () -> String = "Didn't throw expected error",
    file: StaticString = #file,
    line: UInt = #line,
    errorHandler: (Error) -> Void = { _ in }
) {
    _XCAssertThrownErrorIsExpected(expression, errorComparator: errorComparator, message, file: file, line: line, errorHandler: errorHandler)
}
#else
@inlinable
public func XCAssertThrownErrorIsExpected<ExpectedError, T>(
    _ expression: @autoclosure () throws -> T,
    errorComparator: (ExpectedError) -> Bool,
    _ message: @autoclosure () -> String = "Didn't throw expected error",
    file: StaticString = #file,
    line: UInt = #line,
    errorHandler: (Error) -> Void = { _ in }
) {
    _XCAssertThrownErrorIsExpected(expression, errorComparator: errorComparator, message, file: file, line: line, errorHandler: errorHandler)
}
#endif

#endif
