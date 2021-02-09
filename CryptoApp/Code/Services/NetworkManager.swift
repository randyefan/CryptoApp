//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIError: String {
    case networkError
    case apiError
    case decodingError
}

enum APIs: URLRequestConvertible {
    case topList(limit: Int, currency: String)
    case latestNews(language: String, category: String)
    
    static let endpoint = URL(string: "https://min-api.cryptocompare.com/data")!
    static let apiKey = "f61d95eb05b672df065e3f3701fbd4a3d5efde15d3759ebee8a31fd7e17d125d"
    
    var path: String {
        switch self {
        case .topList(_, _):
            return "/top/totaltoptiervolfull"
        case .latestNews(_, _):
            return "/v2/news/"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: URLEncoding {
        return URLEncoding.init(destination: .methodDependent, arrayEncoding: .noBrackets)
    }
    
    func addApiHeaders(request: inout URLRequest) {
        request.addValue(Self.apiKey, forHTTPHeaderField: "authorization")
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Self.endpoint.appendingPathComponent(path))
        var parameters = Parameters()
        
        switch self {
        case .topList(limit: let limit, currency: let currency):
            parameters["limit"] = limit
            parameters["tsym"] = currency
        case .latestNews(language: let language, category: let category):
            parameters["lang"] = language
            parameters["categories"] = category
        }
        
        addApiHeaders(request: &request)
        request = try encoding.encode(request, with: parameters)
        return request
    }
    
}

struct NetworkManager {
    let jsonDecoder = JSONDecoder()
    
    func getTopList(completion: @escaping(JSON?, APIError?) -> ()) {
        Alamofire.request(APIs.topList(limit: 50, currency: "USD")).validate().responseJSON { json in
            switch json.result {
            case .success(let jsonData):
                if let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys) {
                    do {
                        let data = try JSON(data: json)
                        completion(data, nil)
                    } catch {
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            case .failure:
                completion(nil, .apiError)
            }
        }
    }
    
    func getLatestNews(query: String, completion: @escaping(JSON?, APIError?) -> ()) {
        Alamofire.request(APIs.latestNews(language: "EN", category: query)).validate().responseJSON { json in
            switch json.result {
            case .success(let jsonData):
                if let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys) {
                    do {
                        let data = try JSON(data: json)
                        completion(data, nil)
                    } catch {
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            case .failure:
                completion(nil, .apiError)
            }
        }
    }
}

