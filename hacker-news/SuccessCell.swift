//
//  SuccessCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 06/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

final class SuccessCell: ItemCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func configure(item item: Item, indexPath: NSIndexPath) {
        super.configure(item: item, indexPath: indexPath)
        
        titleLabel.text = item.title
        refreshTextColor()
        refreshAccessoryType()
    }
    
    func refreshAccessoryType() {
        if let _ = item?.url {
            accessoryType = .DisclosureIndicator
        } else {
            accessoryType = .None
        }
    }
    
    func refreshTextColor() {
        if item?.readed == true {
            titleLabel.textColor = UIColor.grayColor()
        } else {
            titleLabel.textColor = UIColor.darkTextColor()
        }
    }
    
    func setReaded() {
        item?.setReaded(true, synchronizeWithICloud: true)
        refreshTextColor()
    }
}
