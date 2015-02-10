//
//  Scoreboard.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/8/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit
import GameKit

class Scoreboard {
    
    var viewController:GameViewController?
    let scoreboard = SKLabelNode(text: "Score: 0")
    var score: Int = 0
    var isHighScore = false

    init(x: CGFloat, y: CGFloat) {
        scoreboard.setScale(2.5)
        scoreboard.fontName = "timeburner"
        scoreboard.position = CGPoint(x: x, y: y)
        scoreboard.horizontalAlignmentMode = .Left
    }
    
    func highScore() {
        if score > NSUserDefaults.standardUserDefaults().integerForKey("highscore") {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            isHighScore = true
            viewController?.gameCenter.reportScore(score: score, leaderboardIdentifier: "leaderBoardID")
        }
    }
    
    func addTo(parentNode: GameScene) -> Scoreboard {
        parentNode.addChild(scoreboard)
        return self
    }
    
    func addScore(score: Int) {
        self.score += score
        scoreboard.text = "Score: \(self.score)"
        highScore()
    }
    
    func getScore() -> Int {
        return score
    }
    
    func isHighscore() -> Bool {
        return isHighScore
    }
    
    func getHighscoreLabel(size: CGSize) -> SKLabelNode {
        let highscore = SKLabelNode(text: "High Score!")
        highscore.position = CGPointMake(size.width/2, size.height/2 + 50)
        highscore.fontColor = UIColor.redColor()
        highscore.fontSize = 80
        highscore.fontName = "timeburner"
        highscore.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeInWithDuration(0.3), SKAction.fadeOutWithDuration(0.3)])))
        return highscore
    }
}