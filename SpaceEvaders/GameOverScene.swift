//
//  GameOverScene.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/27/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let score:Int
    init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "EvadeEnd")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(2.3)
        self.addChild(background)
        drawScore()
    }
    
    func drawScore() {
        let label = SKLabelNode(text: "Score: " + String(score))
        label.position = CGPoint(x: size.width / 2, y: size.height/5)
        label.setScale(2.5)
        addChild(label)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
        view?.presentScene(gameScene, transition: reveal)
    }
}