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
    var scoreboard: Scoreboard!
    var rocket: Rocket!
    var aliens = NSMutableSet()
    var powerups = NSMutableSet()

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        Background(main: self)
        rocket = Rocket(x: size.width/2, y: size.height/2).addTo(self) as Rocket
        scoreboard = Scoreboard(x: 50, y: size.height - size.height/5).addTo(self)
        scoreboard.viewController = self.viewController
        Pause(size: size, x: size.width - 50, y: size.height - size.height/6).addTo(self)
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
        default:
            currentlyTouching = true
        }
    }
    
    var pausemenu: PopupMenu!
    func pauseGame() {
        let isPaused = view?.paused.boolValue
        if (isPaused!) {
            pauseUnpause()
            pausemenu.removeThis()
            viewController?.removeAd()
        } else {
            if (!isGameOver) {
                pausemenu = PopupMenu(size: size, named: "Continue?", title: "Paused", id: "pause")
                pausemenu.addTo(self)
                pausemenu.button.background.runAction(SKAction.runBlock({self.pauseUnpause()}))
                viewController?.addAd()
            }
        }
    }
    
    func pauseUnpause() {
        let pause = view?.paused.boolValue
        view?.paused = !pause!
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!isGameOver) {
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
            powerup.sprite.runAction(
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
        let exp = Explosion(x: rocket.sprite.position.x, y: rocket.sprite.position.y).addTo(self) as Explosion
        exp.boom(self)
        rocket.sprite.removeFromParent()
        viewController?.addAd()
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
            if CGRectIntersectsRect(CGRectInset(alien.sprite.frame, 25, 25), CGRectInset(self.rocket.sprite.frame, 10, 10)) {
                gameOver()
            }
            let y = alien.sprite.position.y
            //disabled by laser
            if !alien.isDisabled() {
                let middle = size.height/2
                let startAtTop = alien.startAtTop.boolValue
                if ((!startAtTop && y > middle) || (startAtTop && y < middle)) {
                    alien.setDisabled()
                    scoreboard.addScore(1)
                }
            }
            alien.moveTo(rocket.sprite.position.x, y: rocket.sprite.position.y)
            if (y < 0 || y > size.height) {
                alien.sprite.removeFromParent()
                aliens.removeObject(alien)
            }
        }
    }
    
    func hitPowerup() {
        for powerup in powerups {
            let powerup = powerup as Powerup
            if CGRectIntersectsRect(CGRectInset(powerup.sprite.frame, 5, 5), self.rocket.sprite.frame) {
                powerups.removeObject(powerup)
                var explosion = Explosion(x: powerup.sprite.position.x, y: powerup.sprite.position.y)
                powerup.sprite.removeFromParent()
                explosion.addTo(self)
                explosion.boom(self)
            }
        }
    }
}
