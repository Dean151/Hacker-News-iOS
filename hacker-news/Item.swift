//
//  Item.swift
//  hacker-news
//
//  Created by Thomas Durand on 05/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

/*

{
"by" : "justin",
"id" : 192327,
"score" : 6,
"text" : "Justin.tv is the biggest ...",
"time" : 1210981217,
"title" : "Justin.tv is looking for a Lead Flash Engineer!",
"type" : "job",
"url" : ""
}

*/

import Foundation

import Alamofire

protocol ItemDelegate {
    func itemWillLoad(item: Item)
    func itemDidLoaded(item: Item)
    func itemDidFailLoading(item: Item)
}

class Item: Equatable {
    
    static func itemBaseUrl(id: Int) -> String {
        return "https://hacker-news.firebaseio.com/v0/item/\(id).json"
    }
    
    let id: Int
    var isLoaded = false
    var failLoading = false
    var delegate: ItemDelegate?
    
    var title: String?
    var text: String?
    var url: String?
    
    private var _readed = false
    var readed: Bool {
        get {
            return _readed
        }
        set {
            if _readed != newValue {
                _readed = newValue
                
                // Persistence
                var readedStories = Settings.ReadedStories.value as! [Int]
                if readed {
                    readedStories.append(id)
                    Settings.ReadedStories.setValue(readedStories)
                } else {
                    if let index = readedStories.indexOf(id) {
                        readedStories.removeAtIndex(index)
                        Settings.ReadedStories.setValue(readedStories)
                    }
                }
            }
        }
    }
    
    func setReaded(readed: Bool, synchronizeWithICloud: Bool) {
        self.readed = readed
        if synchronizeWithICloud {
            Settings.ReadedStories.syncWithiCloud()
        }
    }
    
    init(id: Int, loadIt: Bool) {
        self.id = id
        
        let readedStories = Settings.ReadedStories.value as! [Int]
        _readed = readedStories.contains(id)
        
        if loadIt {
            self.loadFromId()
        }
    }
    
    func loadFromId() {
        self.failLoading = false
        self.isLoaded = false
        Alamofire.request(.GET, Item.itemBaseUrl(self.id)).responseJSON { (response) -> Void in
            if let data = response.result.value as? [String: AnyObject] {
                self.isLoaded = true
                self.failLoading = false
                self.title = data["title"] as? String
                self.text = data["text"] as? String
                self.url = data["url"] as? String
                
                self.delegate?.itemDidLoaded(self)
            } else {
                self.failLoading = true
                self.delegate?.itemDidFailLoading(self)
            }
        }
    }
    
    func loadFromButton() {
        self.loadFromId()
        self.delegate?.itemWillLoad(self)
    }
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.id == rhs.id
}
