//
//  Settings.swift
//  hacker-news
//
//  Created by Thomas Durand on 08/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import Foundation

class Settings {
    
    static let instance = Settings()
    
    private init() {
        // Default values
        if (userDefault.objectForKey(useSafariReaderKey) == nil) {
            useSafariReader = true
        }
    }
    
    private let userDefault = NSUserDefaults.standardUserDefaults()
    
    private let useSafariReaderKey = "useSafariReader"
    var useSafariReader: Bool {
        get {
            return userDefault.boolForKey(useSafariReaderKey)
        }
        set {
            userDefault.setBool(newValue, forKey: useSafariReaderKey)
        }
    }
    
}