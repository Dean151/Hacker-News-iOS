//
//  FailureCell.swift
//  hacker-news
//
//  Created by Thomas Durand on 06/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

class FailureCell: ItemCell {
    
    @IBAction func retry(sender: UIButton) {
        item?.loadFromButton()
    }
}
