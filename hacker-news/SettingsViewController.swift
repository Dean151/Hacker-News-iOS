//
//  SettingsViewController.swift
//  hacker-news
//
//  Created by Thomas Durand on 09/04/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import Eureka

class SettingsViewController: FormViewController {
    
    weak var newsVC: NewsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isInPopover = self.navigationController?.popoverPresentationController?.arrowDirection ?? .Unknown != .Unknown
        self.navigationController?.navigationBarHidden = isInPopover
        
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(SettingsViewController.close))
        
        form +++ Section("Opening Links")
            <<< Settings.UseSafariReader.row!
            <<< Settings.OpenInSafari.row!
        
        +++ Section("Readed Stories")
            <<< (Settings.ReadedStories.row as! ButtonRow).onCellSelection { cell, row in
                let alert = UIAlertController(title: "This will reset readed stories data from all your devices", message: "Are you sure you want to proceed?", preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { _ in
                    self.newsVC?.items.forEach({ $0.readed = false })
                    Settings.ReadedStories.syncWithiCloud()
                    self.newsVC?.tableView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                alert.popoverPresentationController?.sourceView = cell
                alert.popoverPresentationController?.sourceRect = cell.bounds
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
