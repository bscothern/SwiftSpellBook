//
//  XCTAssertIdentical.swift
//  SwiftSpellBook
//
//  Created by Braden Scothern on 6/8/2021
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if canImport(XCTest) && !os(watchOS) && swift(<5.4)
import XCTest

/// Asserts that two values are identical.
///
/// - Note: This is a backport of this function from Swift 5.4.
///
/// - Parameters:
///   - expression1: An optional expression of type AnyObject.
///   - expression2: A second optional expression of type AnyObject.
///   - message: An optional description of a failure.
///   - file: The file where the failure occurs.
///         The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs.
///         The default is the line number where you call this function.
@inlinable
public func XCTAssertIdentical(
    _ expression1: @autoclosure () throws -> AnyObject?,
    _ expression2: @autoclosure () throws -> AnyObject?,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let expression1Value: AnyObject?
    let expression2Value: AnyObject?
    do {
        expression1Value = try expression1()
        expression2Value = try expression2()
    } catch {
        XCTFail(message(), file: file, line: line)
        return
    }

    XCTAssert(expression1Value === expression2Value, message(), file: file, line: line)
}

#endif
