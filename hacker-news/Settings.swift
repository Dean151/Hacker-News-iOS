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
    
    var description: String {
        switch self {
        case .UseSafariReader:
            return "Use reader mode by default"
        }
    }
    
    var value: AnyObject {
        switch self {
        case .UseSafariReader:
            return NSUserDefaults.standardUserDefaults().boolForKey(self.rawValue)
        }
    }
    
    func setValue(value: AnyObject?) {
        switch self {
        case .UseSafariReader:
            return NSUserDefaults.standardUserDefaults().setBool(value as! Bool, forKey: self.rawValue)
        }
    }
    
    var row: BaseRow {
        switch self {
        case .UseSafariReader:
            return SwitchRow(self.rawValue) {
                $0.title = self.description
                $0.value = self.value as? Bool
            }.onChange {
                self.setValue($0.value)
            }
        }
    }
}