//
//  PauseMenu.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/9/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class PauseMenu {
    var pause: Button
    var menu: Button
    var paused: SKLabelNode
    
    init(size: CGSize) {
        pause = Button(x: 3*size.width/5, y: size.height/3, width: 7*size.width/20, height: size.height/6, named: "Continue?", id: "pausemenu")
        menu = Button(x: 3*size.width/10, y: size.height/3, width: 2*size.width/10, height: size.height/6, named: "<Menu", id: "backtomenu")

        paused = SKLabelNode(text: "Paused")
        addText(CGPointMake(size.width/2, 3*size.height/5))
    }
    
    func addText(position: CGPoint) {
        paused.fontName = "timeburner"
        paused.fontSize = 200
        paused.color = UIColor.whiteColor()
        paused.position = position
    }
    
    func addTo(parentNode: SKScene) -> PauseMenu {
        pause.addTo(parentNode)
        menu.addTo(parentNode)
        parentNode.addChild(paused)
        return self
    }
    
    func removeThis() {
        pause.removeThis()
        menu.removeThis()
        paused.removeFromParent()
    }
}