//
//  HistoryDataStoreTests.swift
//  CareemTestUITests
//
//  Created by Arun Kumar Nama on 30/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import XCTest

class HistoryDataStoreTests: XCTestCase {
    var testee: HistoryDataStore!
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
 
    func testSaveHistory()  {
        let expectedName = "movie name"
        try? HistoryDataStore.saveSearch(expectedName);
        XCTAssertEqual(HistoryDataStore.retriveHistory().first, expectedName);
    }
    
    func testSaveHistoryWithEmptyString() {
        XCTAssertThrowsError(try HistoryDataStore.saveSearch("")) { (error) -> Void in
            XCTAssertEqual(error as? HistoryDataStoreError, HistoryDataStoreError.EmptySaveOperation)
        }
    }
    
    func testSaveHistoryWithMoreThanHistoryCount() {
        for _ in 1...20 {
            let expectedName = "movie name "
            try? HistoryDataStore.saveSearch(expectedName);
        }
        XCTAssertEqual(HistoryDataStore.retriveHistory().count, 10)
    }
}