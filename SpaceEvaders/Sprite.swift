//
//  Sprite.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/1/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Sprite {
    let sprite = SKSpriteNode()
    
    init(imageNamed:String, name:String, x:CGFloat, y:CGFloat) {
        sprite.texture = SKTexture(imageNamed: imageNamed)
        sprite.position = CGPoint(x: x, y: y)
        sprite.size = sprite.texture!.size()
        sprite.setScale(2)
        sprite.name = name
    }
    
    convenience init(imageNamed:String, x:CGFloat, y:CGFloat) {
        self.init(imageNamed: imageNamed, name: "sprite", x: x, y: y)
    }
    
    convenience init(imageNamed:String, x:CGFloat, y:CGFloat, scale:CGFloat) {
        self.init(imageNamed: imageNamed, name: "sprite", x: x, y: y)
        sprite.setScale(scale)
    }
    
    func addTo(parentNode: GameScene) -> Sprite {
        parentNode.addChild(sprite)
        return self
    }
}