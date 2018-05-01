//
//  SearchUITests.swift
//  CareemTestUITests
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import XCTest

class SearchUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonDecodeWithValidData()  {
        let searchClient = SearchMovie()
        let jsonTestData = SearchUITests.testData()
        
        searchClient.jsonDecode(jsonTestData!) { (movieResults, error) in
            XCTAssertNotNil(movieResults)
            XCTAssertEqual(movieResults.page, 1)
        }
    }
    
    func testJsonDecodeWithInValidData()  {
        let searchClient = SearchMovie()
        let jsonTestData = SearchUITests.testInvalidData()
        
        searchClient.jsonDecode(jsonTestData!) { (movieResults, error) in
            XCTAssertEqual(error, MovieError.InvalidData)
        }
    }
    
    func testSearchApiCall() {
        
        let searchResultExpectation = expectation(description: "Search Expectation")
        let searchClient = SearchMovie()
        
        searchClient.search(name: "Batman", page: 1) { (movieResults, error) in
            searchResultExpectation.fulfill();
        }
        waitForExpectations(timeout: 100, handler: nil);
    }

    static func testData() ->Data? {
        let bundle = Bundle (for: self)
        guard let url = bundle.url(forResource: "Movies", withExtension: "json") else {
            return nil
        }
        let json = try? Data(contentsOf: url)
        return json
    }
    
    static func testInvalidData() ->Data? {
        let json = Data(base64Encoded: "aGVsbG8gaG93IGFyZSAgeW91IA==")
        return json
    }
    
}
