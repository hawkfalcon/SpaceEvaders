//
//  Sprite.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/1/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Sprite : SKSpriteNode {
    init(named:String, x:CGFloat, y:CGFloat) {
        let texture = SKTexture(imageNamed: named)
        super.init(texture:texture,color:nil,size:texture!.size())
        self.position = CGPoint(x: x, y: y)
        self.setScale(2)
        self.name = named
    }
    
    convenience init(named:String, x:CGFloat, y:CGFloat, scale:CGFloat) {
        self.init(named: named, x: x, y: y)
        self.setScale(scale)
    }
    
    convenience init(named:String, x:CGFloat, y:CGFloat, size:CGSize) {
        self.init(named: named, x: x, y: y)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTo(parentNode: SKNode) -> Sprite {
        parentNode.addChild(self)
        return self
    }
}