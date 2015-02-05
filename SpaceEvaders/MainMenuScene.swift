//
//  MainMenuScene.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/27/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    var viewController:GameViewController?
    var info: Sprite!
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        stars()
        PopupMenu(size: size, named: "Play", title: "Space Evaders", id: "start").addTo(self)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as UITouch
        let touchedNode = self.nodeAtPoint(touch.locationInNode(self))
        if (touchedNode.name != nil) {
            tappedButton(touchedNode.name!)
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
            info = Sprite(imageNamed: "Howto", name: "howto", x: size.width/2, y: size.height/2)
            info.size = CGSizeMake(size.width, size.height)
            info.zPosition = 1001
            addChild(info)
        case "howto":
            info.removeFromParent()
        case "twitter":
            socialMedia("twitter")
        case "facebook":
            socialMedia("facebook")
        default:
            println("???")
        }
    }
    
    func socialMedia(social:String) {
        NSNotificationCenter.defaultCenter().postNotificationName("social", object: nil, userInfo:["score":"-1", "type" : "com.apple.social." + social])
    }
    
    func stars() {
        for _ in 1...500 {
            let rand = random() % 6
            let star = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: rand, height: rand))
            star.position = CGPoint(x: random() % Int(size.width), y: random() % Int(size.height))
            self.addChild(star)
        }
    }
}