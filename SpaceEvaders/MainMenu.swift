//
//  MainMenu.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/9/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class MainMenu {
    var start: Button
    var over: SKLabelNode
    
    init(size: CGSize) {
        start = Button(x: size.width/2, y: size.height/3, width: size.width/3, height: size.height/6, named: "Play", id: "start")
        over = SKLabelNode(text: "Space Evaders")
        addLogo(CGPointMake(size.width/2, 3*size.height/5))
    }
    
    func addLogo(position: CGPoint) {
        over.fontName = "timeburner"
        over.fontSize = 200
        over.color = UIColor.whiteColor()
        over.position = position
    }

    func addTo(parentNode: SKScene) -> MainMenu {
        start.addTo(parentNode)
        parentNode.addChild(over)
        return self
    }
}