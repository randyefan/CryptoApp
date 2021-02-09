//
//  TickerTableViewCell.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import UIKit
import RxSwift

class TickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTicker: UILabel!
    @IBOutlet weak var fullNameTicker: UILabel!
    @IBOutlet weak var priceTicker: UILabel!
    @IBOutlet weak var viewLivePrice: UIView!
    @IBOutlet weak var labelLivePrice: UILabel!
    
    override class func description() -> String {
        return "TickerCell"
    }
    
    func configure(viewModel: TickerViewModel) {
        nameTicker.text = viewModel.name
        fullNameTicker.text = viewModel.fullName
        if viewModel.newPrice == 0 {
            priceTicker.text = viewModel.price.currencyFormattedWithSeparator
        } else {
            priceTicker.text = viewModel.newPrice.currencyFormattedWithSeparator
        }
        labelLivePrice.text = viewModel.getLabelLiveUpdate()
        
        if viewModel.getDifferentPrice() < 0 {
            viewLivePrice.backgroundColor = .red
            labelLivePrice.textColor = .white
        } else {
            viewLivePrice.backgroundColor = .systemGreen
            labelLivePrice.textColor = .white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
