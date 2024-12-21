//
//  XCAssertThrownErrorIsExpectedTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 5/7/21.
//  Copyright © 2020-2023 Braden Scothern. All rights reserved.
//

#if !os(watchOS) && swift(>=5.4)
import XCTest
import XCTestSpellBook

final class XCAssertThrownErrorIsExpectedTests: XCTestCase {
    static let defaultCompactDescription = "XCTAssertTrue failed - Didn't throw expected error"

    struct ErrorI: Error, Equatable {
        var i: Int
    }

    enum ErrorE: Error {
        case a
        case b
        case unknown(Swift.Error)
    }

    enum ErrorEqutable: Error, Equatable {
        case a
    }

    func testXCAssertThrownErrorIsExpectedEqutable() throws {
        func thrower() throws {
            throw ErrorI(i: 321)
        }

        XCAssertThrownErrorIsExpected(
            try thrower(),
            expects: ErrorI(i: 321),
            errorHandler: { error in
                XCTAssert(error is ErrorI)
            }
        )

        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            issue.type == .assertionFailure && issue.compactDescription == Self.defaultCompactDescription
        }

        try XCTExpectFailure(options: options) {
            XCAssertThrownErrorIsExpected(
                try thrower(),
                expects: ErrorI(i: 123)
            )
        }
    }

    func testXCAssertThrownErrorIsExpectedNotEquatable() throws {
        func thrower() throws {
            throw ErrorE.a
        }

        XCAssertThrownErrorIsExpected(
            try thrower(),
            errorComparator: { (error: ErrorE) in
                switch error {
                case .a:
                    true
                default:
                    false
                }
            },
            errorHandler: { error in
                XCTAssert(error is ErrorE)
            }
        )

        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            issue.type == .assertionFailure && issue.compactDescription == Self.defaultCompactDescription
        }

        try XCTExpectFailure(options: options) {
            XCAssertThrownErrorIsExpected(
                try thrower(),
                errorComparator: { (_: Error) in
                    false
                }
            )
        }
    }

    func testXCAssertThrownErrorIsExpectedIsNotExpected() throws {
        let expectedCompactDescription = "failed - Didn't throw expected error"

        typealias ExpectedError = ErrorI
        typealias UnexpectedError = ErrorEqutable

        func thrower() throws {
            throw UnexpectedError.a
        }

        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            issue.type == .assertionFailure && issue.compactDescription == expectedCompactDescription
        }

        try XCTExpectFailure(options: options) {
            XCAssertThrownErrorIsExpected(
                try thrower(),
                expects: ErrorI(i: 42),
                errorHandler: { error in
                    XCTAssert(error is UnexpectedError)
                }
            )
        }
    }

    func testXCAssertThrownErrorIsExpectedExpectedDeafultErrorHandlerIsOk() {
        func thrower() throws {
            throw ErrorE.a
        }

        XCAssertThrownErrorIsExpected(
            try thrower(),
            errorComparator: { (error: ErrorE) in
                switch error {
                case .a:
                    true
                default:
                    false
                }
            }
        )
    }
}
#endif
