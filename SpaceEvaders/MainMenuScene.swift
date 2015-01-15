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
        otherButtons()
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
            info.sprite.size = CGSizeMake(size.width, size.height)
            info.sprite.zPosition = 1001
            addChild(info.sprite)
        case "howto":
            info.sprite.removeFromParent()
        default:
            println("???")
        }
    }
    
    func otherButtons() {
        let info = Sprite(imageNamed: "info", name: "info", x: size.width - size.width/15, y: size.height - size.height/5)
        info.sprite.size = CGSizeMake(size.height/12, size.height/12)
        addChild(info.sprite)
        /*let settings = Sprite(imageNamed: "settings", name: "settings", x: size.width/15, y: size.height - size.height/5)
        settings.sprite.size = CGSizeMake(size.height/12, size.height/12)
        addChild(settings.sprite)*/
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