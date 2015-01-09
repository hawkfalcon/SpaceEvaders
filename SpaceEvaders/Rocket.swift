//
//  Rocket.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/8/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Rocket : Sprite {
    var fireArray = Array<SKTexture>();

    init(x: CGFloat, y: CGFloat) {
        super.init(imageNamed:"rocket", name:"rocket", x: x, y: y)
        sprite.setScale(3)
        fire()
        tapableArea()
    }
    
    func tapableArea() {
        var tapableSprite = SKSpriteNode()
       // tapableSprite.color = UIColor.whiteColor()
        tapableSprite.size = CGSizeMake(sprite.size.width * 1.2, sprite.size.height)
        tapableSprite.name = "tap"
        sprite.addChild(tapableSprite)
    }
    
    func fire() {
        for index in 0...2 {
            fireArray.append(SKTexture(imageNamed: "fire" + String(index)))
        }
        var fire = SKSpriteNode(texture:fireArray[0]);
        fire.anchorPoint = CGPoint(x: 0.5, y: 1.3)
        sprite.addChild(fire)
        let animateAction = SKAction.animateWithTextures(self.fireArray, timePerFrame: 0.10);
        fire.runAction(SKAction.repeatActionForever(animateAction))
    }
}
