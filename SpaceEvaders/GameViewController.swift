//
//  GameViewController.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/24/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import Social

class GameViewController: UIViewController, ADBannerViewDelegate {
    var gameCenter: GameCenter!
    var adBannerView: ADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenuScene(size:CGSize(width: 2048, height: 1536))
        let skView = self.view as SKView
        self.gameCenter = GameCenter(rootViewController: self)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        scene.viewController = self
        skView.presentScene(scene)
        loadAds()
        addAd()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareAction:", name: "social", object: nil)
    }
    
    func loadAds() {
        adBannerView = ADBannerView(frame: CGRectMake(0, 0, view.bounds.size.width, 32))
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
    }
    
    override func shouldAutorotate() -> Bool{
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool  {
        return true
    }

    func shareAction(notification:NSNotification) {
        let score = notification.userInfo!["score"] as String
        let type = notification.userInfo!["type"] as NSString
        if SLComposeViewController.isAvailableForServiceType(type){
            let social = SLComposeViewController(forServiceType: type)
            var text = "I scored " + score + " in Space Evaders! Can you beat that? https://appsto.re/us/lgcg5.i"
            if (score == "-1") {
                text = "Check out the iPhone game Space Evaders! https://appsto.re/us/lgcg5.i"
            }
            social.setInitialText(text)
            self.presentViewController(social, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to your social media account to share!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "I will", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func openGC() {
        gameCenter.showGameCenter()
    }
    
    func addAd() {
        view.addSubview(adBannerView)
    }
    
    func removeAd() {
        adBannerView.removeFromSuperview()
    }
    
    func hasAd() -> Bool {
       return adBannerView.isDescendantOfView(view)
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewWillLoadAd")
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        self.adBannerView.hidden = false
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NSLog("bannerViewActionShouldBegin")
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("bannerView")
    }

}
