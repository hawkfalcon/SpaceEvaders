import SpriteKit

class FadeText {
    let text: SKLabelNode
    
    init(x: CGFloat, y: CGFloat, label: String) {
        text = SKLabelNode(text: label)
        text.position = CGPoint(x: x, y: y)
        text.fontName = "timeburner"
        text.color = UIColor.white
        text.fontSize = 25
        text.zPosition = 500
        text.verticalAlignmentMode = .bottom
    }
    
    func addTo(parent: SKNode) {
        parent.addChild(text)
        text.run(
            SKAction.sequence([
                SKAction.scale(by: 1.2, duration: 1.0),
                SKAction.fadeAlpha(by: -0.9, duration: 0.6),
                SKAction.removeFromParent()
            ])
        )
    }
}
