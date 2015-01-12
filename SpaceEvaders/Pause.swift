//
//  Pause.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/9/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//
import SpriteKit

class Pause {
    var gameover: SKSpriteNode
    
    init(size: CGSize, x: CGFloat, y: CGFloat) {
        gameover = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: size.width/3, height: size.height/6))
        gameover.position = CGPoint(x: x, y: y);
        gameover.zPosition = 1000
        gameover.name = "pause"
        addPause()
    }
    
    func addPause() {
        let text = SKLabelNode(text: "=")
        text.fontName = "timeburner"
        text.name = "pause"
        text.fontSize = 100
        text.zRotation = CGFloat(M_PI_2)
        text.horizontalAlignmentMode = .Right
        gameover.addChild(text)
    }
    
    func addTo(parentNode: GameScene) -> Pause {
        parentNode.addChild(gameover)
        return self
    }
}