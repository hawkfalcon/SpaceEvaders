//
//  GameScene.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 12/24/14.
//  Copyright (c) 2014 Tristen Miller. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
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
    }
    
    var dragged: SKNode!
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch : UITouch = touches.anyObject() as UITouch
        let touchedNode = self.nodeAtPoint(touch.locationInNode(self))
        if (touchedNode.name == "tap") {
            self.dragged = rocket.sprite
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch : UITouch = touches.anyObject() as UITouch
        if (self.dragged != nil) {
            self.dragged.position = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.dragged = nil
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!isGameOver) {
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
        let gameOverScene = GameOverScene(size: size, score: scoreboard.getScore())
        gameOverScene.scaleMode = scaleMode
        let reveal = SKTransition.crossFadeWithDuration(0.5)
        view?.presentScene(gameOverScene, transition: reveal)
    }
    
    func alienLogic() {
        for alien in aliens {
            let alien = alien as Alien
            if CGRectIntersectsRect(CGRectInset(alien.sprite.frame, 20, 20), self.rocket.sprite.frame) {
                rocket.sprite.removeFromParent()
                gameOver()
            }
            let y = alien.sprite.position.y
            //disabled by laser
            if !alien.isDisabled() {
                let middle = size.height/2
                if ((!alien.startAtTop.boolValue && y > middle) || (alien.startAtTop.boolValue && y < middle)) {
                    alien.setDisabled()
                    scoreboard.addScore(5)
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
