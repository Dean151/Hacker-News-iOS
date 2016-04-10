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
    
    var description: String {
        switch self {
        case .UseSafariReader:
            return "Open in reader mode if available"
        case .OpenInSafari:
            return "Open links in Safari"
        }
    }
    
    var defaultValue: AnyObject {
        switch self {
        case .UseSafariReader:
            return true
        case .OpenInSafari:
            return false
        }
    }
    
    var value: AnyObject? {
        // Default value
        if NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue) == nil {
            return self.defaultValue
        }
        
        switch self.defaultValue {
        case is Bool:
            return NSUserDefaults.standardUserDefaults().boolForKey(self.rawValue)
        default:
            return nil
        }
    }
    
    func setValue(value: AnyObject?) {
        switch self.defaultValue {
        case is Bool:
            NSUserDefaults.standardUserDefaults().setBool(value as! Bool, forKey: self.rawValue)
        default:
            break
        }
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
            return nil
        }
    }
}