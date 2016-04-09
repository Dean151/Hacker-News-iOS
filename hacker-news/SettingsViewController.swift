//
//  SettingsViewController.swift
//  hacker-news
//
//  Created by Thomas Durand on 09/04/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import Eureka

class SettingsViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isInPopover = self.navigationController?.popoverPresentationController?.arrowDirection ?? .Unknown != .Unknown
        self.navigationController?.navigationBarHidden = isInPopover
        
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(SettingsViewController.close))
        
        form +++ Section("Safari")
            <<< Settings.UseSafariReader.row
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
