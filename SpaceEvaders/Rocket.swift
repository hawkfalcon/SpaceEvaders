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
        super.init(named:"rocket", x: x, y: y)
        self.setScale(2.5)
        fire()
    }
    
    func fire() {
        for index in 0...2 {
            fireArray.append(SKTexture(imageNamed: "fire\(index)"))
        }
        var fire = SKSpriteNode(texture:fireArray[0]);
        fire.anchorPoint = CGPoint(x: 0.5, y: 1.3)
        self.addChild(fire)
        let animateAction = SKAction.animateWithTextures(self.fireArray, timePerFrame: 0.10);
        fire.runAction(SKAction.repeatActionForever(animateAction))
    }
    
    func moveTo(x: CGFloat, y: CGFloat) {
        let speed: CGFloat = 12
        var dx: CGFloat, dy: CGFloat
        // Compute vector components in direction of the touch
        dx = x - self.position.x
        dy = y - self.position.y + 50
        self.zRotation = atan2(dy + 100, dx) - CGFloat(M_PI_2)
        //Do not move if tap is on sprite
        if (dx >= 1 || dx <= -1) && (dy >= 1 || dy <= 1) {
            let mag = sqrt(dx*dx+dy*dy)
            // Normalize and scale
            dx = dx/mag * speed
            dy = (dy + 50)/mag * speed
            self.position = CGPointMake(self.position.x+dx, self.position.y+dy)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
