//
//  NewsListViewController.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var newsListViewModel: NewsListViewModel?
    let disposeBag = DisposeBag()
    
    var category: String? {
        didSet {
            self.newsListViewModel = NewsListViewModel(query: category ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerObserver()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    func registerObserver() {
        guard let newsListViewModel = self.newsListViewModel else {
            return
        }
        newsListViewModel.news.drive(onNext: { [unowned self] (_) in
            self.newsTableView.reloadData()
            }).disposed(by: disposeBag)
        newsListViewModel.error.drive(onNext: { [unowned self] (error) in
            self.infoLabel.isHidden = !self.newsListViewModel!.hasError
            self.infoLabel.text = error
            }).disposed(by: disposeBag)
        newsListViewModel.isFetching.drive(activityIndicator.rx.isHidden).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 44.0;
        newsTableView.register(NewsTableViewCell().asNib(), forCellReuseIdentifier: NewsTableViewCell.description())
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel?.numberOfList ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return newsListViewModel?.prepareCellForDisplay(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
}
