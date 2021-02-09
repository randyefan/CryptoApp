//
//  News.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation
import SwiftyJSON

struct News {
    var source: String
    var title: String
    var body: String
    
    init(_ json: JSON) {
        source = json["source_info"]["name"].stringValue
        title = json["title"].stringValue
        body = json["body"].stringValue
    }
}
