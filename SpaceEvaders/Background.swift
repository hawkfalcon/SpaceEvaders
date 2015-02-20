import SpriteKit

class Background {
    let background = SKNode()
    var size: CGSize
    init(main: GameScene) {
        background.zPosition = -1
        self.size = main.size
        fadeMainLaser()
        backAndForth()
        Sprite(named: "laserside", x: size.width/100, y: size.height/2).addTo(background)
        Sprite(named: "laserside", x: size.width - size.width/100, y: size.height/2).addTo(background)
        background.addChild(Utility.skyFullofStars(size.width, height: size.height))
        main.addChild(background)
    }
    
    func fadeMainLaser() {
        let laser = Sprite(named: "laser", x: size.width/2, y: size.height/2, scale: 2.3).addTo(background)
        laser.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.fadeAlphaBy(-0.75, duration: 1.0),
                SKAction.fadeAlphaBy(0.75, duration: 1.0),
                ])
            )
        )
    }
    
    func backAndForth() {
        let lasermove = Sprite(named: "lasermove", x: 0, y: size.height/2).addTo(background)
        lasermove.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.moveTo(CGPoint(x: size.width, y: size.height/2), duration: 2),
                SKAction.moveTo(CGPoint(x: 0, y: size.height/2), duration: 2),
                ])
            ))
    }
}
