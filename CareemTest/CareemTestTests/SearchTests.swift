//
//  SearchTests.swift
//  CareemTestTests
//
//  Created by Arun Kumar Nama on 1/5/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import XCTest
class SearchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testJsonDecodeWithValidData()  {
        let searchClient = SearchMovie()
        let jsonTestData = SearchTests.testData()

        searchClient.jsonDecode(jsonTestData!) { (movieResults, error) in
            XCTAssertNotNil(movieResults)
            XCTAssertEqual(movieResults.page, 1)
        }
    }
    
  
    static func testData() ->Data? {
        let bundle = Bundle (for: self)
        guard let url = bundle.url(forResource: "Movies", withExtension: "json") else {
            return nil
        }
        let json = try? Data(contentsOf: url)
        return json
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
