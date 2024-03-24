//
//  MonitoredArrayTests.swift
//  WordsHelperTests
//
//  Created by Mark Liu on 1/14/24.
//

import XCTest

@testable import WordsHelper

final class MonitoredArrayTests: XCTestCase {
    /// Test the functionality of `MonitoredArray`.
    // Use ! or will report has no initializers
    private var freqArr: MonitoredArray<String, NSNumber>!
    private var key: String!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        key = "stringValue"
        freqArr = try MonitoredArray(key: key, [NSNumber(value: 91), 
                                                NSNumber(value: 1324),
                                                NSNumber(value: 1324),
                                                NSNumber(value: 41)])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        key = nil
        freqArr = nil
    }
    
    func testFreq() throws {
        /// Test if frequency is calculated correctly.
        XCTAssertEqual(freqArr.freq("1234"), 2)
    }
    
    func testInsert() throws {
        /// Test if `insert` correctly updates frequency.
        var freq = freqArr.freq("41")
        try freqArr.insert(NSNumber(value: 41))
        XCTAssertEqual(freqArr.freq("41"), freq + 1)
    }
    
    func testRemove() throws {
        /// Test if `remove` correctly updates frequency.
        try freqArr.insert(NSNumber(value: 2132))
        var freq = freqArr.freq("2132")
        freqArr.remove(at: freqArr.endIndex)
        XCTAssertEqual(freqArr.freq("2132"), freq - 1)
    }
    
    func testNonExistElement() throws {
        /// Test if nonexistent element has frequency 0.
        XCTAssertEqual(freqArr.freq("194825783"), 0)
    }
    
    func testSetValue() throws {
        /// Test functionality of `setValue`.
        try freqArr.setValue(NSNumber(value: 867), at: 3)
        XCTAssertEqual(freqArr.freq("867"), 3)
    }
    
    func testModifyData() throws {
        /// Test if data can be modified externally.
        let prevCount = freqArr.count
        var testArr = freqArr.data
        testArr.removeAll()
        XCTAssertEqual(freqArr.count, prevCount)
    }
    
    func testModifyFreq() throws {
        /// Test if `freq` cannot be modified externally.
        var dist = freqArr.distribution()
        dist.removeAll()
        XCTAssertEqual(freqArr.freq("41"), 1)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
