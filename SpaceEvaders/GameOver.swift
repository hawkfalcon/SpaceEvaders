//
//  GameOver.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/9/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class GameOver {
    var gameover: Button
    var over: SKLabelNode
    
    init(size: CGSize) {
        gameover = Button(x: size.width/2, y: size.height/3, width: size.width/3, height: size.height/6, named: "Play Again?", id: "gameover")
        over = SKLabelNode(text: "Game Over!")
        addGameOver(CGPointMake(size.width/2, 3*size.height/5))
    }
    
    func addGameOver(position: CGPoint) {
        over.fontName = "timeburner"
        over.fontSize = 100
        over.color = UIColor.whiteColor()
        over.position = position
    }
    
    func addTo(parentNode: GameScene) -> GameOver {
        gameover.addTo(parentNode)
        parentNode.addChild(over)
        return self
    }
}