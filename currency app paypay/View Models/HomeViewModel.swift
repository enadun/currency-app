//
//  HomeViewModel.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import UIKit

class HomeViewModel {
    private(set) var selectedCurrencyKey: String?
    private(set) var currncyAmount: Double?
    private(set) var currencySummery: CurrencySummery?
    private var currencyList: [String: String]?
    private let currencyService: CurrencyServiceType
    
    init() {
        //        currencyService = CurrencyService()
        currencyService = MockCurrencyService()
        selectedCurrencyKey = "USD"
        currncyAmount = 1
    }
    
    func setSelectedCurrencyKey(selectedCurrency: String?) {
        self.selectedCurrencyKey = selectedCurrency
    }
    func setCurrencyAmount(amount: Double) {
        self.currncyAmount = amount
    }
    func getCurrncyList(completion: @escaping (Bool) -> ()) {
        currencyService.getCurrencyList { [weak self] result in
            switch result {
            case .success(let model):
                self?.currencyList = model.currencies
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
            print(result)
        }
    }
    
    func getCurrncyRates(completion: @escaping (Bool) -> ()) {
        if let lastTimeStamp = currencySummery?.timestamp {
            if Date().timeIntervalSince1970 - lastTimeStamp > Config.request_time_interval {
                return completion(true)
            }
        }
        currencyService.getCurrencyRates { [weak self] result in
            switch result {
            case .success(let model):
                let currencySummery = CurrencySummery(timestamp: Date().timeIntervalSince1970,
                                                      currencyList: self?.currencyList,
                                                      currencyRates: model.quotes)
                self?.currencySummery = currencySummery
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
            print(result)
        }
    }
    
    func getCurrencyName(for key: String) -> String {
        return currencySummery?.currencyList?[key] ?? ""
    }
    
    func getCurrencyRateStringFor(key: String) -> String {
        let rate = getCurrencyRateFor(key: key)
        let rateString = getFormattedCurrencyString(for: rate, with: 4)
        return "1 \(selectedCurrencyKey ?? "USD") = \(rateString) \(key)"
    }
    
    func getCurrencyAmountStringFor(key: String) -> String {
        let rate = getCurrencyRateFor(key: key)
        let amount = rate * (currncyAmount ?? 1)
        print("\(key) \(amount)")
        switch amount {
        case 0.0..<1.0:
            return getFormattedCurrencyString(for: amount, with: 4)
        case 1.0..<1000000.0:
            return getFormattedCurrencyString(for: amount, with: 2)
        default:
            return "\(getFormattedCurrencyString(for: amount, with: 1))M"
        }

    }
    
    private func getCurrencyRateFor(key: String) -> Double {
        let selectedRateKey = "USD\(selectedCurrencyKey ?? "USD")"
        let selectedRateWithUSD = currencySummery?.currencyRates?[selectedRateKey] ?? 1
        let requestedRateKey = "USD\(key)"
        let requestdRateWithUSD = currencySummery?.currencyRates?[requestedRateKey] ?? 1
        return requestdRateWithUSD / selectedRateWithUSD
    }
}
