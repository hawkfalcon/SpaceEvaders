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
    var viewController:GameViewController!

    init(vc: GameViewController, size: CGSize) {
        super.init(size: size)
        viewController = vc
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        stars()
        let main = PopupMenu(size: size, named: "Play", title: "Space Evaders", id: "start").addTo(self)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as UITouch
        let touchedNode = self.nodeAtPoint(touch.locationInNode(self))
        if (touchedNode.name == "start") {
            let gameScene = GameScene(vc: viewController, size: size)
            gameScene.scaleMode = scaleMode
            let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
            view?.presentScene(gameScene, transition: reveal)
        } else if (touchedNode.name == "leaderboard") {
            viewController.openGC()
        }
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