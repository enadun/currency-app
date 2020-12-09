//
//  FileManager.swift
//  currency app paypay
//
//  Created by Nadun De Silva on 20/Dec/09.
//  Copyright © 2020 Nadun De Silva. All rights reserved.
//

import UIKit

class DataManager {
    private static let currency_summery = "currency_summery"
    
    func saveCurrencyData(with currencySummery: CurrencySummery) {
        saveDataToCash(data: currencySummery, fileName: DataManager.currency_summery)
    }
    
    func loadCurrencyData() -> CurrencySummery? {
        loadFileFromCache(fileName: DataManager.currency_summery)
    }
    
    private func saveDataToCash<T: Codable>(data: T, fileName: String) {
        if let filePath = getCacheDirectoryFor()?
            .appendingPathComponent(fileName)
            .appendingPathExtension("json") {
            if let data = try? JSONEncoder().encode(data) {
                try? data.write(to: filePath)
            }
        }
    }
    
    private func loadFileFromCache<T: Codable>(fileName: String) -> T? {
        do {
            if let filePath = getCacheDirectoryFor()?
                .appendingPathComponent(fileName)
                .appendingPathExtension("json") {
                let data = try Data(contentsOf: filePath)
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            }
            return nil
        } catch _ {
            return nil
        }
    }
    
    private func getCacheDirectoryFor() -> URL? {
        if let reqDirectory = getDocumentsDirectory()?
            .appendingPathComponent("cache") {
            //Checking the directotry is exist, othervise create before returning the path.
            if !FileManager.default.fileExists(atPath: reqDirectory.path) {
                do {
                    try FileManager.default.createDirectory(at: reqDirectory,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                } catch {
                    print(error)
                    return nil
                }
            }
            return reqDirectory
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}
