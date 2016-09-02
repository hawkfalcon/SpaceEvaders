import SpriteKit

class Button {
    var button: SKSpriteNode

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, label: String, id: String) {
        button = SKSpriteNode(color: UIColor.orange, size: CGSize(width: width, height: height))
        button.position = CGPoint(x: x, y: y);
        button.zPosition = 10
        button.name = id
        addText(label: label, id: id)
    }

    func addText(label: String, id: String) {
        let text = SKLabelNode(text: label)
        text.fontName = "timeburner"
        text.name = id
        text.fontSize = 100
        text.verticalAlignmentMode = .center
        button.addChild(text)
    }

    func addToSelf(parent: SKNode) -> SKSpriteNode {
        parent.addChild(button)
        return button
    }
    
    func addTo(parent: SKNode) {
        parent.addChild(button)
    }

    func removeThis() {
        button.removeFromParent()
    }
}
