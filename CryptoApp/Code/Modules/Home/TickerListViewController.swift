//
//  TickerListViewController.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import UIKit
import RxSwift

class TickerListViewController: UIViewController {

    @IBOutlet weak var tickerTableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tickerListViewModel = TickerListViewModel()
    let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Toplists";
        self.registerObserver()
        self.setupTableView()
        self.setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    func registerObserver() {
        tickerListViewModel.tickers.drive(onNext: { [unowned self] (tickers) in
            // To Handle Scrolling Performance
            if (!tickerTableView.isDragging && !tickerTableView.isDecelerating) {
                self.tickerTableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        tickerListViewModel.error.drive(onNext: { [unowned self] (error) in
            self.infoLabel.isHidden = !self.tickerListViewModel.hasError
            self.infoLabel.text = error
            }).disposed(by: disposeBag)
        tickerListViewModel.isFetching.drive(activityIndicator.rx.isHidden).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        if #available(iOS 10.0, *) {
            tickerTableView.refreshControl = refreshControl
        } else {
            tickerTableView.addSubview(refreshControl)
        }
        tickerTableView.delegate = self
        tickerTableView.dataSource = self
        tickerTableView.rowHeight = UITableView.automaticDimension
        tickerTableView.register(TickerTableViewCell().asNib(), forCellReuseIdentifier: TickerTableViewCell.description())
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshTickerData), for: .valueChanged)
    }
    
    @objc private func refreshTickerData() {
        tickerListViewModel.getTickerList()
    }
    
}

extension TickerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickerListViewModel.numberOfList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tickerListViewModel.prepareCellForDisplay(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tickerViewModel = tickerListViewModel.viewModelForTicker(at: indexPath.row)
        guard let newsVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListViewController") as? NewsListViewController else {
            return
        }
        newsVC.category = tickerViewModel?.name ?? ""
        self.navigationController?.present(newsVC, animated: true)
    }
}
