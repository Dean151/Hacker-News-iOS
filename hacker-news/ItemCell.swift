//
//  ItemCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 05/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(item item: Item) {
        
        if item.isLoaded {
            
            self.titleLabel.text = item.title
            
            if let _ = item.url {
                self.accessoryType = .DisclosureIndicator
            }
            
            self.activityIndicator.stopAnimating()
            
        } else {
            // Reinit
            self.accessoryType = .None
            self.titleLabel.text = nil
            
            self.activityIndicator.startAnimating()
            item.loadFromId()
        }
    }
}
