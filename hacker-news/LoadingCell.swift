//
//  LoadingCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 06/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

import Shimmer

final class LoadingCell: ItemCell {
    
    @IBOutlet weak var loadingView: FBShimmeringView!
    @IBOutlet weak var loadingWidthConstraint: NSLayoutConstraint!
    
    override func configure(item item: Item, indexPath: NSIndexPath) {
        super.configure(item: item, indexPath: indexPath)
        
        item.loadFromId()
        
        // Loading random width
        loadingWidthConstraint.constant = CGFloat(arc4random_uniform(170)) + 100
        self.setNeedsDisplay()
        
        // Loading effect
        let view = UIView(frame: loadingView.bounds)
        view.backgroundColor = UIColor.hackerLoadingPlaceholderColor
        loadingView.backgroundColor = nil
        loadingView.contentView = view
        loadingView.shimmering = true
    }
}
