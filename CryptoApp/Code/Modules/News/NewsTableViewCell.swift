//
//  NewsTableViewCell.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceNews: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var bodyNews: UILabel!
    
    override class func description() -> String {
        return "NewsCell"
    }
    
    func configure(viewModel: NewsViewModel) {
        sourceNews.text = viewModel.source
        titleNews.text = viewModel.title
        bodyNews.text = viewModel.body
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
