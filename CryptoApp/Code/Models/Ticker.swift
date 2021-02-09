//
//  Ticker.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation
import SwiftyJSON

struct Ticker {
    var name: String
    var fullName: String
    var price: Double
    var newPrice: Double = 0
    
    init(_ json: JSON) {
        name = json["CoinInfo"]["Name"].stringValue
        fullName = json["CoinInfo"]["FullName"].stringValue
        price = json["RAW"]["USD"]["PRICE"].doubleValue
    }
    
    func getSubsName() -> String {
        return "2~Coinbase~\(name)~USD"
    }
}
