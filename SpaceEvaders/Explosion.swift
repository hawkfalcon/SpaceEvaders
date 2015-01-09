//
//  Explosion.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/7/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Explosion : Sprite {
    init(x: CGFloat, y: CGFloat) {
        super.init(imageNamed: "shockwave", name: "bm", x: x, y: y)
    }
    
    func boom(main: GameScene) {
        sprite.addChild(newExplosion())
        sprite.runAction(
            SKAction.sequence([
                SKAction.scaleBy(7, duration: 0.5),
                SKAction.runBlock({self.removeAliens(main)}),
                SKAction.fadeAlphaBy(-0.9, duration: 0.6),
                SKAction.removeFromParent()
            ])
        )

    }
    
    func removeAliens(main: GameScene) {
        for alien in main.aliens {
            let alien = alien as Alien
            main.aliens.removeObject(alien)
            alien.sprite.removeFromParent()
        }
    }
    
    private func newExplosion() -> SKEmitterNode {
        
        let explosion = SKEmitterNode()
        
        let image = UIImage(named:"shockwave.png")!
        explosion.particleTexture = SKTexture(image: image)
        explosion.particleColor = UIColor.brownColor()
        explosion.numParticlesToEmit = 20
        explosion.particleBirthRate = 20
        explosion.particleLifetime = 1
        explosion.emissionAngleRange = 360
        explosion.particleSpeed = 100
        explosion.particleSpeedRange = 50
        explosion.particleAlpha = 0.8
        explosion.particleAlphaRange = 0.2
        explosion.particleAlphaSpeed = -0.5
        explosion.particleScale = 1.0
        explosion.particleScaleRange = 0.5
        explosion.particleScaleSpeed = -0.5
        explosion.particleBlendMode = SKBlendMode.Add
        
        return explosion
    }
}
