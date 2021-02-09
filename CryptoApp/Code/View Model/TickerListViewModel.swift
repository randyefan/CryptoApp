//
//  TickerListViewModel.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import Starscream

class TickerListViewModel {
    private var networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    private let webSocketManager: WebSocketManager
    
    private let _tickers = BehaviorRelay<[Ticker]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isConnectedWebSocket = false
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var tickers: Driver<[Ticker]> {
        return _tickers.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfList: Int {
        return _tickers.value.count
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.webSocketManager = WebSocketManager.shared
        webSocketManager.webSocket.delegate = self
        self.getTickerList()
    }
    
    func getTickerList() {
        networkManager.getTopList { response, error in
            self._isFetching.accept(true)
            
            if error != nil {
                self._error.accept(error.map{$0.rawValue})
                self._isFetching.accept(false)
                return
            }
            
            // Fetch Response to Array
            var tickers: [Ticker] = []
            guard let data = response else {
                return
            }
            
            for object in data["Data"].arrayValue {
                tickers.append(Ticker(object))
            }
            self._tickers.accept(tickers)
        }
        
        self._isFetching.accept(false)
    }
    
    private func addSubsToWebSocket(tickers: [Ticker]) {
        WebSocketManager.shared.sendSubs(tickers: tickers)
    }
    
    func viewModelForTicker(at index: Int) -> TickerViewModel? {
        guard index < _tickers.value.count else {
            return nil
        }
        return TickerViewModel(ticker: _tickers.value[index])
    }
    
    func prepareCellForDisplay(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TickerTableViewCell.description(), for: indexPath) as? TickerTableViewCell {
            let tickers = _tickers.value
            cell.configure(viewModel: TickerViewModel(ticker: tickers[indexPath.row]))
            return cell
        }
        fatalError()
    }
}

extension TickerListViewModel: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                isConnectedWebSocket = true
                self.addSubsToWebSocket(tickers: _tickers.value)
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnectedWebSocket = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("Received text: \(string)")
                
                let json = JSON.init(parseJSON: string)
                
                //Handle Add Subs to Web Socket
                if json["TYPE"].intValue == 3 {
                    self.addSubsToWebSocket(tickers: _tickers.value)
                }
                
                //Handle WebSocket Response For CoinBase
                if json["TYPE"].intValue == 2 {
                    let old = _tickers.value.map { $0.name == json["FROMSYMBOL"].stringValue }
                    if let pos = old.firstIndex(of: true) {
                        var value = _tickers.value
                        value[pos].newPrice = json["PRICE"].doubleValue
                        self._tickers.accept(value)
                    }
                }
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnectedWebSocket = false
            case .error(_):
                isConnectedWebSocket = false
            }
    }
    
}
