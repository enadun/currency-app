//
//  Currency.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/08.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

// MARK: - CurrencyRatesModel
struct CurrencyRatesModel: Codable {
    let success: Bool?
    let timestamp: Int?
    let source: String?
    let quotes: [String: Double]?
}

// MARK: - CurrencyListModel
struct CurrencyListModel: Codable {
    let success: Bool?
    let currencies: [String: String]?
}

struct CurrencySummery: Codable {
    let timestamp: Double?
    let currencyList: [String: String]?
    let currencyRates: [String: Double]?
}
