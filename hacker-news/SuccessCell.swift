//
//  SuccessCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 06/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

class SuccessCell: ItemCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func configure(item item: Item, indexPath: NSIndexPath) {
        super.configure(item: item, indexPath: indexPath)
        
        self.titleLabel.text = item.title
        
        if let _ = item.url {
            self.accessoryType = .DisclosureIndicator
        }
    }
}
