import SpriteKit

class Pause {
    var pause: SKSpriteNode
    
    init(size: CGSize, x: CGFloat, y: CGFloat) {
        pause = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(size.width/3, size.height/6))
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
        text.horizontalAlignmentMode = .Right
        pause.addChild(text)
    }
    
    func addTo(parentNode: GameScene) -> Pause {
        parentNode.addChild(pause)
        return self
    }
    
    func removeThis() {
        pause.removeFromParent()
    }
}