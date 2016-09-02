import SpriteKit

class Pause {
    var pause: SKSpriteNode

    init(size: CGSize, x: CGFloat, y: CGFloat) {
        pause = SKSpriteNode(color: UIColor.clear, size: CGSize(width: size.width / 3, height: size.height / 6))
        pause.position = CGPoint(x: x, y: y);
        pause.zPosition = 10
        pause.name = "pause"
        addPause()
    }

    func addPause() {
        let text = SKLabelNode(text: "=")
        text.fontName = "timeburner"
        text.name = "pause"
        text.fontSize = 100
        text.zRotation = CGFloat(M_PI_2)
        text.horizontalAlignmentMode = .right
        pause.addChild(text)
    }

    func addTo(parent: GameScene) -> Pause {
        parent.addChild(pause)
        return self
    }

    func removeThis() {
        pause.removeFromParent()
    }
}
