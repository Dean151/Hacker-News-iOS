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
    func itemDidLoaded(item: Item)
    func itemDidFailLoading(item: Item)
}

class Item: Equatable {
    
    static func itemBaseUrl(id: Int) -> String {
        return "https://hacker-news.firebaseio.com/v0/item/\(id).json"
    }
    
    let id: Int
    var isLoaded = false
    var delegate: ItemDelegate?
    
    var title: String?
    var text: String?
    var url: String?
    
    init(id: Int, loadIt: Bool) {
        self.id = id
        
        if loadIt {
            self.loadFromId()
        }
    }
    
    func loadFromId() {
        Alamofire.request(.GET, Item.itemBaseUrl(self.id)).responseJSON { (response) -> Void in
            if let data = response.result.value as? [String: AnyObject] {
                self.isLoaded = true
                self.title = data["title"] as? String
                self.text = data["text"] as? String
                self.url = data["url"] as? String
                
                self.delegate?.itemDidLoaded(self)
            } else {
                self.delegate?.itemDidFailLoading(self)
            }
        }
    }
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.id == rhs.id
}