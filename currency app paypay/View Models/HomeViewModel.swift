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
    private let dataManager = DataManager()
    
    init(with currencyService: CurrencyServiceType) {
        self.currencyService = currencyService
        selectedCurrencyKey = "USD"
        currncyAmount = 1
    }
    
    func getLastUpdateTimeString() -> String {
        if let timestamp = currencySummery?.timestamp {
            let dateString = getDateTimeString(from: timestamp)
            return String.init(format: Strings.last_update_time, dateString)
        }
        return ""
    }
    
    func setSelectedCurrencyKey(selectedCurrency: String?) {
        self.selectedCurrencyKey = selectedCurrency
    }
    
    func setCurrencyAmount(amount: Double) {
        self.currncyAmount = amount
    }
    
    func loadCurrncyList(completion: @escaping (Bool) -> ()) {
        var timeStamp: Double?
        //Load from memory
        if let currencySummery = currencySummery {
            timeStamp = currencySummery.timestamp
        } else if let currencySummery = dataManager.loadCurrencyData() {
            //Loded from cache
            self.currencySummery = currencySummery
            timeStamp = currencySummery.timestamp
        } //If not available Could be the fist time open and load from the API
        
        if let lastTimeStamp = timeStamp {
            if Date().timeIntervalSince1970 - lastTimeStamp < Config.request_time_interval {
                return completion(true)
            }
        }
        //Load from API
        getCurrencyList(completion: completion)
    }
    
    func getCurrencyList(completion: @escaping (Bool) -> ()) {
        currencyService.getCurrencyList { [weak self] result in
            switch result {
            case .success(let model):
                self?.currencyList = model.currencies
                self?.getCurrncyRates(completion: completion)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func getCurrncyRates(completion: @escaping (Bool) -> ()) {
        currencyService.getCurrencyRates { [weak self] result in
            switch result {
            case .success(let model):
                let currencySummery = CurrencySummery(timestamp: Date().timeIntervalSince1970,
                                                      currencyList: self?.currencyList,
                                                      currencyRates: model.quotes)
                self?.currencySummery = currencySummery
                //Save data to cache
                self?.dataManager.saveCurrencyData(with: currencySummery)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
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
        switch amount {
        case 0.0..<1.0: // If value less then 1 show more decimals
            return getFormattedCurrencyString(for: amount, with: 4)
        case 1.0..<100000000.0:
            return getFormattedCurrencyString(for: amount, with: 2)
        default: // If value is huge, divide by million
            return "\(getFormattedCurrencyString(for: amount / 1000000.0, with: 1))M"
        }
        
    }
    
    // MARK: - Private methods
    private func getCurrencyRateFor(key: String) -> Double {
        let selectedRateKey = "USD\(selectedCurrencyKey ?? "USD")"
        let selectedRateWithUSD = currencySummery?.currencyRates?[selectedRateKey] ?? 1
        let requestedRateKey = "USD\(key)"
        let requestdRateWithUSD = currencySummery?.currencyRates?[requestedRateKey] ?? 1
        return requestdRateWithUSD / selectedRateWithUSD
    }
}
