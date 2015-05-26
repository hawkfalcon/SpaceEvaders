import SpriteKit

class FadeText {
    let text: SKLabelNode
    
    init(x: CGFloat, y: CGFloat, label: String) {
        text = SKLabelNode(text: label)
        text.position = CGPoint(x: x, y: y)
        text.fontName = "timeburner"
        text.color = UIColor.whiteColor()
        text.fontSize = 25
        text.zPosition = 500
        text.verticalAlignmentMode = .Bottom
    }
    
    func addTo(parentNode: SKNode) -> FadeText {
        parentNode.addChild(text)
        text.runAction(
            SKAction.sequence([
                SKAction.scaleBy(1.2, duration: 1.0),
                SKAction.fadeAlphaBy(-0.9, duration: 0.6),
                SKAction.removeFromParent()
            ])
        )
        return self
    }
}
