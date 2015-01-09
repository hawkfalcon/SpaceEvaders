//
//  Powerup.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/2/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

var bombArray = Array<SKTexture>();

class Powerup : Sprite {
    init(x: CGFloat, y: CGFloat) {
        super.init(imageNamed: "powerup1", name: "pu", x: x, y: y)
        sprite.setScale(1.5)
        sprite.alpha = 0
        fire()
    }
    
    func fire() {
        for index in 1...15 {
            bombArray.append(SKTexture(imageNamed: "powerup" + String(index)))
        }
        let animateAction = SKAction.animateWithTextures(bombArray, timePerFrame: 0.10);
        sprite.runAction(SKAction.repeatActionForever(animateAction))
    }
}
