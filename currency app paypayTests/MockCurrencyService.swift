//
//  MockCurrencyService.swift
//  currency app paypayTests
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import UIKit
@testable import Currency_App

class MockCurrencyService {
    static func getDataFor<T: Codable>(fileName: String) -> T? {
        if let path = Bundle(for: MockCurrencyService.self).path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                print("JSON parsing error.")
                return nil
            }
        }
        print("Undefined JSON file.")
        return nil
    }
}

class SuccessMockCurrencyService: CurrencyServiceType {
    func getCurrencyList(completion: @escaping (Result<CurrencyListModel, Error>) -> ()) {
        if let result: CurrencyListModel = MockCurrencyService.getDataFor(fileName: "list") {
            completion(.success(result))
        } else {
            completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }
    }
    
    func getCurrencyRates(completion: @escaping (Result<CurrencyRatesModel, Error>) -> ()) {
        if let result: CurrencyRatesModel = MockCurrencyService.getDataFor(fileName: "rates") {
            completion(.success(result))
        } else {
            completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }
    }
}

class FailedMockCurrencyService: CurrencyServiceType {
    func getCurrencyList(completion: @escaping (Result<CurrencyListModel, Error>) -> ()) {
        completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
    }
    
    func getCurrencyRates(completion: @escaping (Result<CurrencyRatesModel, Error>) -> ()) {
        completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
    }
}

