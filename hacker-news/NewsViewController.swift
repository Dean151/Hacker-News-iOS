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
    let reuseCellIdentifier = "itemCell"
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Creation of refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: Selector("loadData"), forControlEvents: .ValueChanged)
        
        self.loadData(showRefreshControl: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // Mark: - Item Delegate
    
    func itemDidLoaded(item: Item) {
        if let indexPath = indexPathForItem(item) {
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func itemDidFailLoading(item: Item) {
        
    }
    
    // Mark: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as! ItemCell
        
        cell.configure(item: itemAtIndexPath(indexPath)!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

