//
//  CurrencyService.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/08.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import UIKit

protocol CurrencyServiceType {
    func getCurrencyList(completion: @escaping (Result<CurrencyListModel, Error>) -> ())
    func getCurrencyRates(completion: @escaping (Result<CurrencyRatesModel, Error>) -> ())
}

class CurrencyService: CurrencyServiceType {
    func getCurrencyRates(completion: @escaping (Result<CurrencyRatesModel, Error>) -> ()) {
        getData(path: CurrencyEndpoint.liveRates, completion: completion)
    }
    
    func getCurrencyList(completion: @escaping (Result<CurrencyListModel, Error>) -> ()) {
        getData(path: CurrencyEndpoint.list, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func getData<T: Codable>(path: String, completion: @escaping (Result<T, Error>) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.host = Config.CurrencyService.base_url
        urlComponents.path = path
        urlComponents.scheme = "http"
        let queryItems = [URLQueryItem(name: "access_key", value: Keys.currency_service_api_key)]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = Config.request_timeout
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data ?? Data())
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


//TODO: Move this to unit test
class MockCurrencyService: CurrencyServiceType {
    func getCurrencyList(completion: @escaping (Result<CurrencyListModel, Error>) -> ()) {
        if let result: CurrencyListModel = getDataFor(fileName: "list") {
            completion(.success(result))
        } else {
            completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }
    }
    
    func getCurrencyRates(completion: @escaping (Result<CurrencyRatesModel, Error>) -> ()) {
        if let result: CurrencyRatesModel = getDataFor(fileName: "rates") {
            completion(.success(result))
        } else {
            completion(.failure(NSError(domain: "", code: 100, userInfo: nil)))
        }
    }
    
    private func getDataFor<T: Codable>(fileName: String) -> T? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
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
