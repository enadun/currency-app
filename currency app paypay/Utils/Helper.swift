//
//  Helper.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import UIKit

func getFormattedCurrencyString(for value: Double, with decimels: Int = 2) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    formatter.maximumFractionDigits = decimels
    let number = NSNumber(value: value)
    return formatter.string(from: number) ?? "0.00"
}

func testFunc() -> String {
    "Test"
}
