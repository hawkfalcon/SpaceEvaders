//
//  AppDelegate.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/24/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var restartAd = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GCHelper.sharedInstance.authenticateLocalUser()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        let gvc = self.window?.rootViewController as GameViewController
        if gvc.hasAd() {
            restartAd = true
            gvc.removeAd()
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        if restartAd {
            let gvc = self.window?.rootViewController as GameViewController
            gvc.addAd()
            restartAd = false
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }
}

