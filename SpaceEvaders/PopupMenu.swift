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
    var leaderboard: Sprite
    var twitter: Sprite
    var facebook: Sprite
    var info: Sprite

    init(size: CGSize, named: String, title: String, id: String) {
        self.button = Button(x: size.width/2, y: size.height/3, width: size.width/3, height: size.height/6, named: named, id: id)
        self.title = SKLabelNode(text: "" + title)
        self.twitter = Sprite(imageNamed: "twitter", name: "twitter", x: 3*size.width/4, y: size.height/3 + size.height/26)
        self.facebook = Sprite(imageNamed: "facebook", name: "facebook", x: 3*size.width/4, y: size.height/3 - size.height/26)
        twitter.setScale(0.1)
        facebook.setScale(0.1)
        info = Sprite(imageNamed: "info", name: "info", x: size.width - size.width/15, y: size.height - size.height/5)
        info.size = CGSizeMake(size.height/12, size.height/12)
        leaderboard = Sprite(imageNamed: "leaderboard", name: "leaderboard", x: size.width/4, y: size.height/3)
        leaderboard.size = CGSizeMake(size.height/6, size.height/6)
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
        twitter.addTo(parentNode)
        facebook.addTo(parentNode)
        leaderboard.addTo(parentNode)
        info.addTo(parentNode)
        parentNode.addChild(title)
        return self
    }
    
    func removeThis() {
        button.removeThis()
        title.removeFromParent()
        leaderboard.removeFromParent()
        twitter.removeFromParent()
        facebook.removeFromParent()
        info.removeFromParent()
    }
}