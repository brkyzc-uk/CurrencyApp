//
//  FetchData.swift
//  CurrencyApp
//
//  Created by Burak YAZICI on 14/12/2021.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published public var fromIndex = 0
    @Published public var toIndex = 1
    @Published public var amount : String = ""
    @Published public var showingAlert = false
    @Published public var showingSheet = false
    @Published public var showingFromCurrencies = false
    @Published public var showingToCurrencies = false
    @Published var conversionData : [Currency] = []
    public var currencies: [String] {
        return conversionData.map { currency in
            currency.currencyName
        }
    }
    
    
    init() {
        if isLocalDataAvailable() {
            fetchFromLocal()
        } else {
            fetchFromApi()
        }
    }
    
    func getCurrentCurrencyRateText() -> String {
        return "1 \(currencies[fromIndex]) = \(convert("1"))  \(currencies[toIndex])"
    }

    func getFinalAmountText() -> String {
        return " \(currencies[toIndex]) \(convert(amount))"
    }

    func getAlertText() -> String {
        return "Are you about to get \(amount) \(currencies[fromIndex]) for \(convert(amount)) \(currencies[toIndex]) ? Do you approve the transaction?"
    }
    
    func getSuccessText() -> String {
        return "\(amount) \(currencies[fromIndex])  = \(convert(amount)) \(currencies[toIndex])"
    }
    
    func convert(_ convert: String) -> String {
        var conversion: Double = 1.0
        let amount = Double(convert) ?? 0.0
        let usdRates = conversionData.map { currency in
            currency.currencyValue
        }
       
        conversion = amount * (usdRates[toIndex] / usdRates[fromIndex] )
        
        return String(format: "%.2f", conversion)
    }
    
    func fetchFromApi() {

        let url = "https://v6.exchangerate-api.com/v6/b43887bb87a33d2e89deb97f/latest/USD"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string:url)!) { (data, _, _) in
            guard let JSONData = data else {return}
            
            do{
                let conversion = try JSONDecoder().decode(Conversion.self, from: JSONData)
                
                // Convertin Dictionary To Array Of Objects
                DispatchQueue.main.async {
                    self.conversionData = conversion.conversion_rates.compactMap({ (key,value) -> Currency? in
                        return Currency(currencyName: key, currencyValue: value)
                    })
                    self.saveData(data: conversion.conversion_rates)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        .resume()
        
    }
    
    func saveData(data: [String: Double]){
        UserDefaults.standard.set(data, forKey: "ConversionData")
        UserDefaults.standard.set(Date(), forKey: "LastFetchDate")
    }
    
    func fetchFromLocal() {
        if let conversion_rates = UserDefaults.standard.object(forKey: "ConversionData") as? [String: Double] {
            self.conversionData = conversion_rates.compactMap({ (key,value) -> Currency? in
                return Currency(currencyName: key, currencyValue: value)
            })
        }
    }
    
    func isLocalDataAvailable() -> Bool {
        
        if let fetchDate = UserDefaults.standard.object(forKey: "LastFetchDate") as? Date {
            let date = Date()
            let hourDifference = Calendar.current.dateComponents([.hour], from: fetchDate, to: date).hour ?? 0
            return hourDifference < 24
        }
        return false
    }
}
