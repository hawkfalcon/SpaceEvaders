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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        var view: SKView = self.window?.rootViewController?.view as SKView
        view.paused = true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        var view: SKView = self.window?.rootViewController?.view as SKView
        view.paused = false
    }

    func applicationDidEnterBackground(application: UIApplication) {
        //Unused
    }

    func applicationWillEnterForeground(application: UIApplication) {
        //Unused
    }
}

