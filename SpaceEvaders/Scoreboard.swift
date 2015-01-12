//
//  Scoreboard.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/8/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Scoreboard {
    
    let scoreboard = SKLabelNode(text: "Score: 0")
    var score: Int = 0

    init(x: CGFloat, y: CGFloat) {
        scoreboard.setScale(2.5)
        scoreboard.fontName = "timeburner"
        scoreboard.position = CGPoint(x: x, y: y)
        scoreboard.horizontalAlignmentMode = .Left
    }
    
    func addTo(parentNode: GameScene) -> Scoreboard {
        parentNode.addChild(scoreboard)
        return self
    }
    
    func addScore(score: Int) {
        self.score += score
        scoreboard.text = "Score: " + String(self.score)
    }
    
    func getScore() -> Int {
        return score
    }
}