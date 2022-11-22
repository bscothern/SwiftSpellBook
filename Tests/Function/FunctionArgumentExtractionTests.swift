//
//  FunctionArgumentExtractionTests.swift
//  SwiftSpellBookTests
//
//  Created by Braden Scothern on 7/18/22.
//  Copyright © 2020-2022 Braden Scothern. All rights reserved.
//

#if !os(watchOS)
import SwiftFunctionSpellBook
import XCTest

final class FunctionArgumentExtractionTests: XCTestCase {
    static let argumentTypes: [Int: ObjectIdentifier] = [
        1: .init(Int64.self),
        2: .init(Int32.self),
        3: .init(Int16.self),
        4: .init(Int8.self),
        5: .init(UInt64.self),
        6: .init(UInt32.self),
        7: .init(UInt16.self),
        8: .init(UInt8.self),
        9: .init(Double.self),
        10: .init(Float.self),
    ]

    func f2(_: Int64, _: Int32){}
    func f3(_: Int64, _: Int32, _: Int16){}
    func f4(_: Int64, _: Int32, _: Int16, _: Int8){}
    func f5(_: Int64, _: Int32, _: Int16, _: Int8, _: UInt64){}
    func f6(_: Int64, _: Int32, _: Int16, _: Int8, _: UInt64, _: UInt32){}
    func f7(_: Int64, _: Int32, _: Int16, _: Int8, _: UInt64, _: UInt32, _: UInt16){}
    func f8(_: Int64, _: Int32, _: Int16, _: Int8, _: UInt64, _: UInt32, _: UInt16, _: UInt8){}
    func f9(_: Int64, _: Int32, _: Int16, _: Int8, _: UInt64, _: UInt32, _: UInt16, _: UInt8, _: Double){}
    func f10(_: Int64, _: Int32, _: Int16, _: Int8, _: UInt64, _: UInt32, _: UInt16, _: UInt8, _: Double, _: Float){}
    
    func testFunctionArgumentExtraction2() {
        let f = f2
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
    }
    
    func testFunctionArgumentExtraction3() {
        let f = f3
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
    }
    
    func testFunctionArgumentExtraction4() {
        let f = f4
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
    }
    
    func testFunctionArgumentExtraction5() {
        let f = f5
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
        let t5 = extractArgument5Type(f)
        XCTAssertEqual(.init(t5), Self.argumentTypes[5])
    }
    
    func testFunctionArgumentExtraction6() {
        let f = f6
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
        let t5 = extractArgument5Type(f)
        XCTAssertEqual(.init(t5), Self.argumentTypes[5])
        let t6 = extractArgument6Type(f)
        XCTAssertEqual(.init(t6), Self.argumentTypes[6])
    }
    
    func testFunctionArgumentExtraction7() {
        let f = f7
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
        let t5 = extractArgument5Type(f)
        XCTAssertEqual(.init(t5), Self.argumentTypes[5])
        let t6 = extractArgument6Type(f)
        XCTAssertEqual(.init(t6), Self.argumentTypes[6])
        let t7 = extractArgument7Type(f)
        XCTAssertEqual(.init(t7), Self.argumentTypes[7])
    }
    
    func testFunctionArgumentExtraction8() {
        let f = f8
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
        let t5 = extractArgument5Type(f)
        XCTAssertEqual(.init(t5), Self.argumentTypes[5])
        let t6 = extractArgument6Type(f)
        XCTAssertEqual(.init(t6), Self.argumentTypes[6])
        let t7 = extractArgument7Type(f)
        XCTAssertEqual(.init(t7), Self.argumentTypes[7])
        let t8 = extractArgument8Type(f)
        XCTAssertEqual(.init(t8), Self.argumentTypes[8])
    }
    
    func testFunctionArgumentExtraction9() {
        let f = f9
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
        let t5 = extractArgument5Type(f)
        XCTAssertEqual(.init(t5), Self.argumentTypes[5])
        let t6 = extractArgument6Type(f)
        XCTAssertEqual(.init(t6), Self.argumentTypes[6])
        let t7 = extractArgument7Type(f)
        XCTAssertEqual(.init(t7), Self.argumentTypes[7])
        let t8 = extractArgument8Type(f)
        XCTAssertEqual(.init(t8), Self.argumentTypes[8])
        let t9 = extractArgument9Type(f)
        XCTAssertEqual(.init(t9), Self.argumentTypes[9])
    }
    
    func testFunctionArgumentExtraction10() {
        let f = f10
        let t1 = extractArgument1Type(f)
        XCTAssertEqual(.init(t1), Self.argumentTypes[1])
        let t2 = extractArgument2Type(f)
        XCTAssertEqual(.init(t2), Self.argumentTypes[2])
        let t3 = extractArgument3Type(f)
        XCTAssertEqual(.init(t3), Self.argumentTypes[3])
        let t4 = extractArgument4Type(f)
        XCTAssertEqual(.init(t4), Self.argumentTypes[4])
        let t5 = extractArgument5Type(f)
        XCTAssertEqual(.init(t5), Self.argumentTypes[5])
        let t6 = extractArgument6Type(f)
        XCTAssertEqual(.init(t6), Self.argumentTypes[6])
        let t7 = extractArgument7Type(f)
        XCTAssertEqual(.init(t7), Self.argumentTypes[7])
        let t8 = extractArgument8Type(f)
        XCTAssertEqual(.init(t8), Self.argumentTypes[8])
        let t9 = extractArgument9Type(f)
        XCTAssertEqual(.init(t9), Self.argumentTypes[9])
        let t10 = extractArgument10Type(f)
        XCTAssertEqual(.init(t10), Self.argumentTypes[10])
    }
}
#endif
