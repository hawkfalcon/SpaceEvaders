//
//  Button.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/12/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Button {
    var background: SKSpriteNode
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, named: String, id: String) {
        background = SKSpriteNode(color: UIColor.orangeColor(), size: CGSizeMake(width, height))
        background.position = CGPointMake(x, y);
        background.zPosition = 1000
        background.name = id
        addText(named, id: id)
    }
    
    func addText(named: String, id: String) {
        let text = SKLabelNode(text: named)
        text.fontName = "timeburner"
        text.name = id
        text.fontSize = 100
        text.verticalAlignmentMode = .Center
        background.addChild(text)
    }
    
    func addTo(parentNode: SKScene) -> Button {
        parentNode.addChild(background)
        return self
    }
    
    func removeThis() {
        background.removeFromParent()
    }
}