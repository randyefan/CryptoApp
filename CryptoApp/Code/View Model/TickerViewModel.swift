//
//  TickerViewModel.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation

struct TickerViewModel {
    private var ticker: Ticker
    
    init(ticker: Ticker) {
        self.ticker = ticker
    }
    
    var name: String {
        return ticker.name
    }
    
    var fullName: String {
        return ticker.fullName
    }
    
    var price: Double {
        return ticker.price
    }
    
    var newPrice: Double {
        return ticker.newPrice
    }
    
    func getDifferentPrice() -> Double {
        if newPrice == 0 {
            return 0
        }
        return price - newPrice
    }
    
    private func getPercent() -> Double {
        if newPrice == 0 {
            return 0
        }
        let different = price - newPrice
        let percent = (different/price) * 100
        return percent
    }
    
    func getLabelLiveUpdate() -> String {
        if getDifferentPrice() < 0 {
            return "\(getDifferentPrice().differentWithSeparator)\("(\(getPercent().percentWithSeparator))")"
        } else {
            return "+\(getDifferentPrice().differentWithSeparator)\("(+\(getPercent().percentWithSeparator))")"
        }
    }
}
