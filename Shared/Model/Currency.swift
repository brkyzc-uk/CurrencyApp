//
//  Currency.swift
//  CurrencyApp
//
//  Created by Burak YAZICI on 14/12/2021.
//

import SwiftUI

// For Displaying Data
struct Currency: Identifiable {
    
    var id = UUID().uuidString
    var currencyName: String
    var currencyValue: Double
}

