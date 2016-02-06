//
//  ItemCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 05/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    weak var item: Item?
    
    func configure(item item: Item, indexPath: NSIndexPath) {
        
        self.item = item
        
        self.numberLabel.text = "\(indexPath.row + 1)."
    }
}
