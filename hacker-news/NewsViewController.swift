//
//  ViewController.swift
//  hacker-news
//
//  Created by Thomas Durand on 05/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit
import SafariServices

import Alamofire

class NewsViewController: UITableViewController {

    let url = "https://hacker-news.firebaseio.com/v0/topstories.json"
    let itemCellIdentifier = "itemCell"
    let loadingCellIdentifier = "loadingCell"
    let failureCellIdentifier = "failureCell"
    
    var items = [Item]()
    var lastRefresh: NSDate? {
        didSet {
            if let date = lastRefresh {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                dateFormatter.timeStyle = .ShortStyle
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Last refresh on \(dateFormatter.stringFromDate(date))", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            } else {
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting item
        self.navigationItem.title = "Hacker News"
        self.navigationController?.navigationBar.barStyle = .Black
        let settingsItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .Plain, target: self, action: #selector(NewsViewController.openSettings(_:)))
        self.navigationItem.rightBarButtonItem = settingsItem
        
        // Creation of refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.hackerOrangeColor
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action: #selector(NewsViewController.loadData as (NewsViewController) -> () -> ()), forControlEvents: .ValueChanged)
        
        self.lastRefresh = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAutoRefresh {
            self.loadData(showRefreshControl: animated)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openSettings(sender: UIBarButtonItem) {
        let settingsVC = SettingsViewController(style: .Grouped)
        settingsVC.newsVC = self
        let navVC = UINavigationController(rootViewController: settingsVC)
        navVC.modalPresentationStyle = .Popover
        navVC.popoverPresentationController?.barButtonItem = sender
        navVC.preferredContentSize = CGSizeMake(320, 250)
        
        presentViewController(navVC, animated: true, completion: nil)
    }
    
    var shouldAutoRefresh: Bool {
        // No item, we refresh
        if items.count == 0 {
            return true
        }
        
        // Last refreshed 10 minutes ago, we refresh
        if lastRefresh?.compare(NSDate(timeIntervalSinceNow: 60*10)) == .OrderedDescending {
            return true
        }
        
        return false
    }
    
    func loadData() {
        self.loadData(showRefreshControl: false)
    }

    func loadData(showRefreshControl show: Bool) {
        if show {
            self.refreshControl?.beginRefreshing()
        }
        
        self.items.removeAll()
        
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            
            if let ids = response.result.value as? [Int] {
                print("Found \(ids.count) items")
                
                for id in ids {
                    let item = Item(id: id, loadIt: false)
                    item.delegate = self
                    self.items.append(item)
                }
                
                self.lastRefresh = NSDate()
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func indexPathForItem(item: Item) -> NSIndexPath? {
        if let row = self.items.indexOf(item) {
            return NSIndexPath(forRow: row, inSection: 0)
        }
        
        return nil
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> Item? {
        if indexPath.row >= 0 && indexPath.row < self.items.count {
            return self.items[indexPath.row]
        }
        
        return nil
    }
    
    func reloadItem(item: Item) {
        if let indexPath = indexPathForItem(item) {
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    // Mark: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let item = itemAtIndexPath(indexPath) {
            
            var cellID = loadingCellIdentifier
            if item.isLoaded {
                cellID = itemCellIdentifier
            } else if item.failLoading {
                cellID = failureCellIdentifier
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! ItemCell
            
            cell.configure(item: item, indexPath: indexPath)
            
            return cell
        }
        
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }
    
    // Mark: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SuccessCell {
            if let url = cell.item?.url {
                if let nsurl = NSURL(string: url) {
                    cell.setReaded()
                    if Settings.OpenInSafari.value as! Bool == true {
                        UIApplication.sharedApplication().openURL(nsurl)
                    } else {
                        let safariVC = SFSafariViewController(URL: nsurl, entersReaderIfAvailable: Settings.UseSafariReader.value as! Bool)
                        safariVC.delegate = self
                        self.presentViewController(safariVC, animated: true, completion: nil)
                    }
                }
            }
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return itemAtIndexPath(indexPath)?.isLoaded == true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if let item = itemAtIndexPath(indexPath) {
            let action = UITableViewRowAction(style: .Normal,
                                              title: item.readed ? "Mark as unread" : "Mark as read",
                                              handler: { (action, indexPath) in
                item.setReaded(!item.readed, synchronizeWithICloud: true)
                                                
                // Changing the UI accordingly
                (tableView.cellForRowAtIndexPath(indexPath) as? SuccessCell)?.updateTextColor()
                action.title = item.readed ? "Mark as unread" : "Mark as read"
                                                
                // Closing the row action
                tableView.setEditing(false, animated: true)
            })
            action.backgroundColor = UIColor.hackerTableViewActionColor
            return [action]
        }
        
        return nil
    }
}

// Mark: - ItemDelegate

extension NewsViewController: ItemDelegate {
    func itemWillLoad(item: Item) {
        reloadItem(item)
    }
    
    func itemDidLoaded(item: Item) {
        reloadItem(item)
    }
    
    func itemDidFailLoading(item: Item) {
        reloadItem(item)
    }
}

// Mark: - SFSafariViewControllerDelegate

extension NewsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
