//
//  PauseMenu.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/9/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class PopupMenu {
    var button: Button
    var title: SKLabelNode

    init(size: CGSize, named: String, title: String, id: String) {
        self.button = Button(x: size.width/2, y: size.height/3, width: size.width/3, height: size.height/6, named: named, id: id)
        self.title = SKLabelNode(text: "" + title)
        addText(self.title, position: CGPointMake(size.width/2, 3*size.height/5))
    }
    
    func addText(node: SKLabelNode, position: CGPoint) {
        node.fontName = "timeburner"
        node.fontSize = 200
        node.color = UIColor.whiteColor()
        node.position = position
    }
    
    func addTo(parentNode: SKScene) -> PopupMenu {
        button.addTo(parentNode)
        parentNode.addChild(title)
        return self
    }
    
    func removeThis() {
        button.removeThis()
        title.removeFromParent()
    }
}