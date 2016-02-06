//
//  ViewController.swift
//  hacker-news
//
//  Created by Thomas Durand on 05/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

import Alamofire

class NewsViewController: UITableViewController, ItemDelegate {

    let url = "https://hacker-news.firebaseio.com/v0/topstories.json"
    let itemCellIdentifier = "itemCell"
    let loadingCellIdentifier = "loadingCell"
    let failureCellIdentifier = "failureCell"
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Creation of refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.hackerOrange
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action: Selector("loadData"), forControlEvents: .ValueChanged)
        
        self.loadData(showRefreshControl: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
    
    // Mark: - Item Delegate
    
    func itemWillLoad(item: Item) {
        reloadItem(item)
    }
    
    func itemDidLoaded(item: Item) {
        reloadItem(item)
    }
    
    func itemDidFailLoading(item: Item) {
        reloadItem(item)
    }
    
    // Mark: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let item = itemAtIndexPath(indexPath) {
            if item.isLoaded {
                let cell = tableView.dequeueReusableCellWithIdentifier(itemCellIdentifier, forIndexPath: indexPath) as! ItemCell
                
                cell.configure(item: item)
                
                return cell
            } else if item.failLoading {
                let cell = tableView.dequeueReusableCellWithIdentifier(failureCellIdentifier, forIndexPath: indexPath) as! FailureCell
                
                cell.configure(item: item)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(loadingCellIdentifier, forIndexPath: indexPath)
                
                item.loadFromId()
                
                return cell
            }
        }
        
        return UITableViewCell(style: .Default, reuseIdentifier: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

