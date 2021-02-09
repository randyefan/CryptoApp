//
//  NewsListViewModel.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

struct NewsListViewModel {
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    
    private let _news = BehaviorRelay<[News]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var news: Driver<[News]> {
        return _news.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfList: Int {
        return _news.value.count
    }
    
    init(query: String, networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.getNewsList(category: query)
    }
    
    func getNewsList(category: String) {
        networkManager.getLatestNews(query: category) { response, error in
            self._isFetching.accept(true)
            
            if error != nil {
                self._error.accept(error.map{$0.rawValue})
                self._isFetching.accept(false)
                return
            }
            
            // Fetch Response to Array
            var news: [News] = []
            guard let data = response else {
                return
            }
            
            for object in data["Data"].arrayValue {
                news.append(News(object))
            }

            self._news.accept(news)
        }
        self._isFetching.accept(false)
    }
    
    func prepareCellForDisplay(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.description(), for: indexPath) as? NewsTableViewCell {
            let news = _news.value
            cell.configure(viewModel: NewsViewModel(news: news[indexPath.row]))
            return cell
        }
        fatalError()
    }
}
