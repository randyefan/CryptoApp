//
//  SocketManager.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 07/02/21.
//

import Foundation
import Starscream

let url = "wss://streamer.cryptocompare.com/v2"

final class WebSocketManager: NSObject {
    
    static let shared = WebSocketManager()
    var webSocket: WebSocket!
    var isConnected = false
    
    override init() {
        super.init()
        configureWebSocket()
    }
    
    private func configureWebSocket() {
        var request = URLRequest(url: URL(string: "wss://streamer.cryptocompare.com/v2?api_key=\(APIs.apiKey)")!)
        request.timeoutInterval = 5
        webSocket = WebSocket(request: request)
        webSocket.connect()
    }
    
    func closeConnection() {
        webSocket.disconnect()
        webSocket.delegate = nil
    }
    
    func sendSubs(tickers: [Ticker]) {
        var params: [String:Any] = [:]
        var tickerSubs: [String] = []
        for ticker in tickers {
            tickerSubs.append(ticker.getSubsName())
        }
        
        params = ["action": "SubAdd",
                  "subs": tickerSubs]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            webSocket.write(data: data)
            print("send")
        } catch {
            print(error.localizedDescription)
        }
    }
}


