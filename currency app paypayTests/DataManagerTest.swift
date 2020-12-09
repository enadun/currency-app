//
//  DataManagerTest.swift
//  currency app paypayTests
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import XCTest
@testable import Currency_App

class DataManagerTest: XCTestCase {
    var dataManager: DataManager?
    override func setUpWithError() throws {
        dataManager = DataManager()
        XCTAssertNotNil(dataManager)
    }
    
    override func tearDownWithError() throws {
        dataManager = nil
    }
    
    func testSaveAndLoadCurrencyData() throws {
        let currncySummery: CurrencySummery? = MockCurrencyService.getDataFor(fileName: "summery")
        XCTAssertNotNil(currncySummery)
        dataManager?.saveCurrencyData(with: currncySummery!)
        
        let currncySummeryLoded = dataManager?.loadCurrencyData()
        XCTAssertNotNil(currncySummery)
        
        XCTAssertEqual(currncySummery?.timestamp, currncySummeryLoded?.timestamp)
    }
}
