//
//  FormatterExtensions.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 08/02/21.
//

import Foundation

extension Formatter {
    static let currencyWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.numberStyle = .currency
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    static let differentWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    static let percentWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        formatter.groupingSeparator = "."
        return formatter
    }()
}

extension Double {
    var currencyFormattedWithSeparator: String { Formatter.currencyWithSeparator.string(for: self) ?? "" }
    var differentWithSeparator: String { Formatter.differentWithSeparator.string(for: self) ?? "" }
    var percentWithSeparator: String { Formatter.percentWithSeparator.string(for: self) ?? "" }
}
