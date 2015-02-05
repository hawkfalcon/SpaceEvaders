//
//  Sprite.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/1/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Sprite : SKSpriteNode {
    init(imageNamed:String, name:String, x:CGFloat, y:CGFloat) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture:texture,color:nil,size:texture!.size())
        self.position = CGPoint(x: x, y: y)
        self.setScale(2)
        self.name = name
    }
    
    convenience init(imageNamed:String, x:CGFloat, y:CGFloat) {
        self.init(imageNamed: imageNamed, name: "sprite", x: x, y: y)
    }
    
    convenience init(imageNamed:String, x:CGFloat, y:CGFloat, scale:CGFloat) {
        self.init(imageNamed: imageNamed, name: "sprite", x: x, y: y)
        self.setScale(scale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTo(parentNode: SKScene) -> Sprite {
        parentNode.addChild(self)
        return self
    }
}