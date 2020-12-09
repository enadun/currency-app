//
//  HelperTest.swift
//  currency app paypayTests
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import XCTest
@testable import Currency_App

class HelperTest: XCTestCase {

    func testGetFormattedCurrencyString() throws {
        let str1 = getFormattedCurrencyString(for: 1000)
        XCTAssertEqual(str1, "1,000.00")
        let str2 = getFormattedCurrencyString(for: 1000.11111111, with: 4)
        XCTAssertEqual(str2, "1,000.1111")
        let str3 = getFormattedCurrencyString(for: 0.121212121212, with: 6)
        XCTAssertEqual(str3, "0.121212")
        let str4 = getFormattedCurrencyString(for: 102.123)
        XCTAssertEqual(str4, "102.12")
        let str5 = getFormattedCurrencyString(for: 102.1251)
        XCTAssertEqual(str5, "102.13")
        let str6 = getFormattedCurrencyString(for: 102.125)
        XCTAssertEqual(str6, "102.12")
    }
}
