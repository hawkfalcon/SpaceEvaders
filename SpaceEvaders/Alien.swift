//
//  Alien.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/1/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Alien : Sprite {
    var startAtTop: Bool!
    var disabled: Bool = false
    
    init(x: CGFloat, y: CGFloat, startAtTop:Bool) {
        super.init(named: "alien", x: x, y: y)
        self.startAtTop = startAtTop
        self.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(1, duration: 1)))
    }
    
    func setDisabled() {
        disabled = true
        self.texture = SKTexture(imageNamed: "aliendisabled")
    }
    
    func isDisabled() -> Bool {
        return disabled
    }
    
    func moveTo(x: CGFloat, y: CGFloat) {
        var speed = 4 as CGFloat
        var dx: CGFloat = 0
        var dy: CGFloat = startAtTop.boolValue ? -speed : speed
        if !isDisabled() {
            // Compute vector components in direction of the touch
            dx = x - self.position.x
            dy = y - self.position.y
            let mag = sqrt(dx*dx+dy*dy)
            // Normalize and scale
            dx = dx/mag * speed
            dy = dy/mag * speed
        }
        self.position = CGPointMake(self.position.x+dx, self.position.y+dy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}