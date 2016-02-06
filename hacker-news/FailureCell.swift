//
//  FailureCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 06/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

class FailureCell: UITableViewCell {
    
    weak var item: Item?
    
    func configure(item item: Item) {
        self.item = item
    }
    
    @IBAction func retry(sender: UIButton) {
        item?.loadFromButton()
    }
}
