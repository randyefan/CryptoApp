//
//  CellExtensions.swift
//  CryptoApp
//
//  Created by Randy Efan Jayaputra on 06/02/21.
//

import UIKit

extension UITableViewCell {
    func asNib() -> UINib {
        return UINib(nibName: Self.description(), bundle: nil)
    }
}
