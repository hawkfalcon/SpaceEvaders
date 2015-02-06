//
//  Background.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/8/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Background {
    var size: CGSize
    init(main: GameScene) {
        self.size = main.size
        fadeMainLaser(main)
        backAndForth(main)
        Sprite(named: "laserside", x: size.width/100, y: size.height/2).addTo(main)
        Sprite(named: "laserside", x: size.width - size.width/100, y: size.height/2).addTo(main)
        stars(main)
    }
    
    func fadeMainLaser(main: GameScene) {
        let laser = Sprite(named: "laser", x: size.width/2, y: size.height/2, scale: 2.3).addTo(main)
        laser.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.fadeAlphaBy(-0.75, duration: 1.0),
                SKAction.fadeAlphaBy(0.75, duration: 1.0),
                ])
            )
        )
    }
    
    func backAndForth(main: GameScene) {
        let lasermove = Sprite(named: "lasermove", x: 0, y: size.height/2).addTo(main)
        lasermove.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.moveTo(CGPoint(x: size.width, y: size.height/2), duration: 2),
                SKAction.moveTo(CGPoint(x: 0, y: size.height/2), duration: 2),
                ])
            ))
    }
    
    func stars(main: GameScene) {
        for _ in 1...500 {
            let rand = random() % 6
            let star = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: rand, height: rand))
            star.position = CGPoint(x: random() % Int(main.size.width), y: random() % Int(main.size.height))
            main.addChild(star)
        }
    }

}
