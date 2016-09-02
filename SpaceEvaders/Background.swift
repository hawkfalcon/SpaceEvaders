import SpriteKit

class Background {
    let background = SKNode()

    var size: CGSize
    init(size: CGSize) {
        background.zPosition = -1
        self.size = size
        fadeMainLaser()
        backAndForth()
        Sprite(named: "laserside", x: size.width / 100, y: size.height / 2).addTo(parent: background)
        Sprite(named: "laserside", x: size.width - size.width / 100, y: size.height / 2).addTo(parent: background)
        background.addChild(Utility.skyFullofStars(width: size.width, height: size.height))
    }

    func fadeMainLaser() {
        let laser = Sprite(named: "laser", x: size.width / 2, y: size.height / 2, scale: 2.3).addToSelf(parent: background)
        laser.run(SKAction.repeatForever(
        SKAction.sequence([
                SKAction.fadeAlpha(by: -0.75, duration: 1.0),
                SKAction.fadeAlpha(by: 0.75, duration: 1.0),
        ])
        ))
    }

    func backAndForth() {
        let lasermove = Sprite(named: "lasermove", x: 0, y: size.height / 2).addToSelf(parent: background)
        lasermove.run(SKAction.repeatForever(
        SKAction.sequence([
                SKAction.move(to: CGPoint(x: size.width, y: size.height / 2), duration: 2),
                SKAction.move(to: CGPoint(x: 0, y: size.height / 2), duration: 2),
        ])
        ))
    }

    func addToSelf(parent: SKNode) -> SKNode {
        parent.addChild(background)
        return background
    }
    
    func addTo(parent: SKNode) {
        parent.addChild(background)
    }
}
