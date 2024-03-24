//
//  WordsListTests.swift
//  WordsHelperTests
//
//  Created by Mark Liu on 1/14/24.
//

import XCTest
import UniformTypeIdentifiers

@testable import WordsHelper

final class WordsListTests: XCTestCase {
    private var wordsList: WordsList!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        // Read `sample_data1.json`.
        wordsList = try WordsList(path: Bundle.main.url(forResource: "sample_data1",
                                                        withExtension: "json")!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        wordsList = nil
    }
    
    func testInfo() throws {
        /// Test if the file info is properly setup.
        print(wordsList.name)
        XCTAssertEqual(wordsList.language, "en")
        print(wordsList.readOnly)
        XCTAssertEqual(wordsList.words.count, 5)
    }
    
    func testCreatefile() throws {
        /// Test if file can be created without error.
        // let content = try! wordsList.snapshot(contentType: UTType.json)
        // let decodedData = try JSONSerialization.jsonObject(with: content) as! [String : Any]
        //print(String(data: content, encoding: .utf8))
        let url = Bundle.main.url(forResource: "test_output_data", withExtension: "json")!
        try wordsList.write(to: url, contentType: .json)
        let newList = try! WordsList(path: url)
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
