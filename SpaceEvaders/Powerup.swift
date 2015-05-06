import SpriteKit

var bombArray = Array<SKTexture>();

class Powerup: Sprite {
    init(x: CGFloat, y: CGFloat) {
        super.init(named: "powerup1", x: x, y: y)
        self.name = "powerup"
        self.setScale(1.5)
        self.alpha = 0
        fire()
    }

    func fire() {
        for index in 1 ... 15 {
            bombArray.append(SKTexture(imageNamed: "powerup\(index)"))
        }
        let animateAction = SKAction.animateWithTextures(bombArray, timePerFrame: 0.10);
        self.runAction(SKAction.repeatActionForever(animateAction))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
