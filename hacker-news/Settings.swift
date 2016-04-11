//
//  Settings.swift
//  hacker-news
//
//  Created by Thomas Durand on 08/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import Foundation
import Eureka

enum Settings: String {
    case UseSafariReader = "useSafariReader"
    case OpenInSafari = "openInSafari"
    case ReadedStories = "readedStories"
    
    var description: String {
        switch self {
        case .UseSafariReader:
            return "Open in reader mode if available"
        case .OpenInSafari:
            return "Open links in Safari"
        case .ReadedStories:
            return "Unmark all readed stories"
        }
    }
    
    var defaultValue: AnyObject {
        switch self {
        case .UseSafariReader:
            return true
        case .OpenInSafari:
            return false
        case .ReadedStories:
            return [Int]()
        }
    }
    
    var value: AnyObject? {
        
        // iCloud Value
        let keyStore = NSUbiquitousKeyValueStore()
        if let cloudValue = keyStore.objectForKey(self.rawValue) {
            return cloudValue
        }
        
        // Default value
        if NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) == nil {
            return self.defaultValue
        }
        
        switch self.defaultValue {
        case is Bool:
            return NSUserDefaults.standardUserDefaults().boolForKey(self.rawValue)
        default:
            return NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue)
        }
    }
    
    func setValue(value: AnyObject?) {
        switch self.defaultValue {
        case is Bool:
            NSUserDefaults.standardUserDefaults().setBool(value as! Bool, forKey: self.rawValue)
            syncWithiCloud()
        default:
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
        }
    }
    
    func syncWithiCloud() {
        let keyStore = NSUbiquitousKeyValueStore()
        keyStore.setObject(value, forKey: self.rawValue)
        keyStore.synchronize()
    }
    
    var row: BaseRow? {
        switch self.defaultValue {
        case is Bool:
            return SwitchRow(self.rawValue) {
                $0.title = self.description
                $0.value = self.value as? Bool
            }.onChange {
                self.setValue($0.value)
            }
        default:
            break
        }
        
        switch self {
        case .ReadedStories:
            return ButtonRow(self.rawValue).cellSetup(){ (cell, row) -> () in
                cell.tintColor = UIColor.hackerOrangeColor
                row.title = self.description
            }
        default:
            break
        }
        
        return nil
    }
}