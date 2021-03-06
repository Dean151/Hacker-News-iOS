//
//  AppDelegate.swift
//  hacker-news
//
//  Created by Thomas Durand on 05/02/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.customizeUI()
        
        Fabric.with([Crashlytics.self])
        
        // register to observe notifications from the store
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.didChangeExternalNotification(_:)), name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: NSUbiquitousKeyValueStore.defaultStore())
        
        // get changes that might have happened while this
        // instance of your app wasn't running
        NSUbiquitousKeyValueStore.defaultStore().synchronize()
        
        return true
    }
    
    func didChangeExternalNotification(notification: NSNotification) {
        if let cloudIds = NSUbiquitousKeyValueStore.defaultStore().objectForKey(Settings.ReadedStories.rawValue) as? [Int],
            var localIds = Settings.ReadedStories.value as? [Int] {
            for id in cloudIds {
                if !localIds.contains(id) {
                    localIds.append(id)
                }
            }
        }
    }
    
    func customizeUI() {
        // Orange
        UINavigationBar.appearance().barTintColor = UIColor.hackerOrangeColor
        UINavigationBar.appearance().translucent = false
        
        // White
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // No border
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

