//
//  LoadingCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 06/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

final class LoadingCell: ItemCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func configure(item item: Item, indexPath: NSIndexPath) {
        super.configure(item: item, indexPath: indexPath)
        
        item.loadFromId()
        activityIndicator.startAnimating()
    }
}
