//
//  GameScene.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/24/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene {
    var viewController:GameViewController?
    let alienSpawnRate = 5
    var isGameOver = false
    var isPaused = false
    var scoreboard: Scoreboard!
    var rocket: Rocket!
    var howto: Sprite!
    var pause: Pause!
    var aliens = NSMutableSet()
    var powerups = NSMutableSet()

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        Background(main: self)
        rocket = Rocket(x: size.width/2, y: size.height/2).addTo(self) as Rocket
        scoreboard = Scoreboard(x: 50, y: size.height - size.height/5).addTo(self)
        scoreboard.viewController = self.viewController
        pause = Pause(size: size, x: size.width - 50, y: size.height - size.height/6).addTo(self)
        viewController?.removeAd()
    }
    
    var currentPosition: CGPoint!
    var currentlyTouching = false
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as UITouch
        currentPosition = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(currentPosition)
        if (touchedNode.name != nil) {
           tappedButton(touchedNode.name!)
        } else {
            currentlyTouching = true
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch : UITouch = touches.anyObject() as UITouch
        currentPosition = touch.locationInNode(self)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        currentlyTouching = false
    }
    
    func tappedButton(name: String) {
        switch name {
        case "gameover":
            resetGame()
        case "pause":
            pauseGame()
        case "leaderboard":
            viewController?.openGC()
        case "twitter":
            socialMedia("twitter")
        case "facebook":
            socialMedia("facebook")
        case "info":
            howto = Sprite(imageNamed: "Howto", name: "howto", x: size.width/2, y: size.height/2)
            howto.size = CGSizeMake(size.width, size.height)
            howto.zPosition = 1001
            addChild(howto)
        case "howto":
            howto.removeFromParent()
        default:
            currentlyTouching = true
        }
    }
    
    func socialMedia(social:String) {
        NSNotificationCenter.defaultCenter().postNotificationName("social", object: nil, userInfo:["score":String(scoreboard.getScore()), "type" : "com.apple.social." + social])
    }
    
    var pausemenu: PopupMenu!
    func pauseGame() {
        if (isPaused) {
            isPaused = false
            speed = 1
            removeDialog()
            viewController?.removeAd()
        } else {
            if (!isGameOver) {
                isPaused = true
                speed = 0
                pause.removeThis()
                pausemenu = PopupMenu(size: size, named: "Continue?", title: "Paused", id: "pause")
                pausemenu.addTo(self)
                viewController?.addAd()
            }
        }
    }
    
    func removeDialog() {
        if (pausemenu != nil) {
           pausemenu.removeThis()
           pause.addPause()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!isGameOver && !isPaused) {
            if (currentlyTouching) {
                rocket.moveTo(currentPosition.x, y: currentPosition.y)
            }
            spawnAliens(true)
            spawnAliens(false)
            alienLogic()
            spawnPowerup()
            hitPowerup()
        }
    }
    
    func spawnAliens(startAtTop: Bool) {
        if random() % 1000 < alienSpawnRate {
            let randomX = 10 + random() % Int(size.width) - 10
            var startY = startAtTop.boolValue ? size.height : 0
            let alien = Alien(x: CGFloat(randomX), y: startY, startAtTop: startAtTop).addTo(self)
            aliens.addObject(alien)
        }
    }
    
    func spawnPowerup() {
        if random() % 1000 < 1 {
            var x = CGFloat(random() % Int(size.width))
            var y = CGFloat(random() % Int(size.height))
            var powerup = Powerup(x: x, y: y).addTo(self)
            powerups.addObject(powerup)
            powerup.runAction(
                SKAction.sequence([
                    SKAction.fadeAlphaTo(1, duration: 0.5),
                    SKAction.waitForDuration(4.5),
                    SKAction.fadeAlphaTo(0, duration: 1.0),
                    SKAction.removeFromParent()
                ])
            )
        }
    }
    
    func gameOver() {
        isGameOver = true
        let exp = Explosion(x: rocket.position.x, y: rocket.position.y).addTo(self) as Explosion
        exp.boom(self)
        rocket.removeFromParent()
        viewController?.addAd()
        pause.removeThis()
        PopupMenu(size: size, named: "Play Again?", title: "Game Over!", id: "gameover").addTo(self)
        if (scoreboard.isHighscore()) {
            addChild(scoreboard.getHighscoreLabel(size))
        }
    }
    
    func resetGame() {
        let gameScene = GameScene(size: size)
        gameScene.viewController = self.viewController
        gameScene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
        view?.presentScene(gameScene, transition: reveal)
    }
    
    func alienLogic() {
        for alien in aliens {
            let alien = alien as Alien
            if CGRectIntersectsRect(CGRectInset(alien.frame, 25, 25), CGRectInset(rocket.frame, 10, 10)) {
                gameOver()
            }
            let y = alien.position.y
            //disabled by laser
            if !alien.isDisabled() {
                let middle = size.height/2
                let startAtTop = alien.startAtTop.boolValue
                if ((!startAtTop && y > middle) || (startAtTop && y < middle)) {
                    alien.setDisabled()
                    scoreboard.addScore(1)
                }
            }
            alien.moveTo(rocket.position.x, y: rocket.position.y)
            if (y < 0 || y > size.height) {
                alien.removeFromParent()
                aliens.removeObject(alien)
            }
        }
    }
    
    func hitPowerup() {
        for powerup in powerups {
            let powerup = powerup as Powerup
            if CGRectIntersectsRect(CGRectInset(powerup.frame, 5, 5), rocket.frame) {
                powerups.removeObject(powerup)
                var explosion = Explosion(x: powerup.position.x, y: powerup.position.y)
                powerup.removeFromParent()
                explosion.addTo(self)
                explosion.boom(self)
            }
        }
    }
}
