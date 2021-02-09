//
//  NewsViewModel.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import Foundation

struct NewsViewModel {
    private var news: News
    
    init(news: News) {
        self.news = news
    }
    
    var source: String {
        return news.source
    }
    
    var title: String {
        return news.title
    }
    
    var body: String {
        return news.body
    }
}
