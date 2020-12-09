//
//  HomeViewModelTest.swift
//  currency app paypayTests
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import XCTest
@testable import Currency_App

class HomeViewModelTest: XCTestCase {
    var currencyService: CurrencyServiceType?
    var viewModel: HomeViewModel?
    
    override func setUpWithError() throws {
        currencyService = SuccessMockCurrencyService()
        XCTAssertNotNil(currencyService)
        
        viewModel = HomeViewModel(with: currencyService!)
        XCTAssertNotNil(viewModel)
        
        let currencySummery: CurrencySummery? = MockCurrencyService.getDataFor(fileName: "summery")
        XCTAssertNotNil(currencySummery)
        DataManager().saveCurrencyData(with: currencySummery!)
    }

    override func tearDownWithError() throws {
        currencyService = nil
        viewModel = nil
    }

    func testGetLastUpdateTimeString() throws {
        let str1 = viewModel?.getLastUpdateTimeString()
        XCTAssertEqual(str1, "") //Because time stamp is `nil`
        
        viewModel?.loadCurrncyList(completion: { succes in
            XCTAssertTrue(succes)
        })
        
        let str2 = viewModel?.getLastUpdateTimeString()
        XCTAssertNotEqual(str2, "")
    }
    
    func testSetSelectedCurrencyKey() throws {
        viewModel?.setSelectedCurrencyKey(selectedCurrency: "XYZ")
        XCTAssertEqual(viewModel?.selectedCurrencyKey!, "XYZ")
    }
    
    func testSetCurrencyAmount() throws {
        viewModel?.setCurrencyAmount(amount: 2000)
        XCTAssertEqual(viewModel?.currncyAmount!, 2000)
    }
    
    func testGetCurrencyList() throws {
        viewModel?.getCurrencyList(completion: { success in
            XCTAssertTrue(success)
        })
        
        viewModel = HomeViewModel(with: FailedMockCurrencyService())
        viewModel?.getCurrencyList(completion: { success in
            XCTAssertFalse(success)
        })
    }
    
    func testGetCurrencyRates() throws {
        viewModel?.getCurrncyRates(completion: { success in
            XCTAssertTrue(success)
        })
        
        viewModel = HomeViewModel(with: FailedMockCurrencyService())
        viewModel?.getCurrncyRates(completion: { success in
            XCTAssertFalse(success)
        })
    }
    
    func testGetCurrencyName() throws {
        viewModel?.loadCurrncyList(completion: { success in
            XCTAssertTrue(success)
        })
        
        let currencyName1 = viewModel?.getCurrencyName(for: "USD")
        XCTAssertEqual(currencyName1, "United States Dollar")
        
        let currencyName2 = viewModel?.getCurrencyName(for: "SLL")
        XCTAssertEqual(currencyName2, "Sierra Leonean Leone")
        
        let currencyName3 = viewModel?.getCurrencyName(for: "MWK")
        XCTAssertEqual(currencyName3, "Malawian Kwacha")
        
        let currencyName4 = viewModel?.getCurrencyName(for: "BAM")
        XCTAssertEqual(currencyName4, "Bosnia-Herzegovina Convertible Mark")
    }
    
    func testGetCurrencyRateStringFor() throws {
        viewModel?.loadCurrncyList(completion: { success in
            XCTAssertTrue(success)
        })
        
        let currencyRate1 = viewModel?.getCurrencyRateStringFor(key: "USD")
        XCTAssertEqual(currencyRate1, "1 USD = 1.00 USD")
        
        viewModel?.setSelectedCurrencyKey(selectedCurrency: "SGD")
        let currencyRate2 = viewModel?.getCurrencyRateStringFor(key: "USD")
        XCTAssertEqual(currencyRate2, "1 SGD = 0.7501 USD")
        
        let currencyRate3 = viewModel?.getCurrencyRateStringFor(key: "BTC")
        XCTAssertEqual(currencyRate3, "1 SGD = 0.00 BTC")
    }
    
    func testGetCurrencyAmountStringFor() throws {
        viewModel?.loadCurrncyList(completion: { success in
            XCTAssertTrue(success)
        })
        
        let currencyAmount1 = viewModel?.getCurrencyAmountStringFor(key: "LKR")
        XCTAssertEqual(currencyAmount1, "186.04")
        
        viewModel?.setCurrencyAmount(amount: 1000)
        let currencyAmount2 = viewModel?.getCurrencyAmountStringFor(key: "LKR")
        XCTAssertEqual(currencyAmount2, "186,039.86")
        
        viewModel?.setSelectedCurrencyKey(selectedCurrency: "BTC")
        let currencyAmount3 = viewModel?.getCurrencyAmountStringFor(key: "LKR")
        XCTAssertEqual(currencyAmount3, "3,608.2M")
        
        viewModel?.setSelectedCurrencyKey(selectedCurrency: "LKR")
        let currencyAmount4 = viewModel?.getCurrencyAmountStringFor(key: "BTC")
        XCTAssertEqual(currencyAmount4, "0.0003")
    }
}
