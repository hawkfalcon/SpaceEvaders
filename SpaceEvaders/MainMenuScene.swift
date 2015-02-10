//
//  MainMenuScene.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/27/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    var viewController:GameViewController?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        addChild(Utility.skyFullofStars(size.width, height: size.height))
        PopupMenu(size: size, title: "Space Evaders", label: "Play", id: "start").addTo(self)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touched = self.nodeAtPoint(touch.locationInNode(self))
        if touched.name != nil {
            let name = touched.name!
            if name == "howto" {
                touched.removeFromParent()
            } else {
                tappedButton(name)
            }
        }
    }
    
    func tappedButton(name: String) {
        switch name {
        case "start":
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
            gameScene.viewController = self.viewController
            view?.presentScene(gameScene, transition: reveal)
        case "leaderboard":
            viewController?.openGC()
        case "info":
            let info = Sprite(named: "howto", x: size.width/2, y: size.height/2, size: CGSizeMake(size.width, size.height)).addTo(self)
            info.zPosition = 1001
        case "twitter":
            Utility.socialMedia("twitter", score: "-1")
        case "facebook":
            Utility.socialMedia("facebook", score: "-1")
        default:
            break
        }
    }
}