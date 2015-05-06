import SpriteKit

class Button {
    var button: SKSpriteNode

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, label: String, id: String) {
        button = SKSpriteNode(color: UIColor.orangeColor(), size: CGSizeMake(width, height))
        button.position = CGPointMake(x, y);
        button.zPosition = 10
        button.name = id
        addText(label, id: id)
    }

    func addText(label: String, id: String) {
        let text = SKLabelNode(text: label)
        text.fontName = "timeburner"
        text.name = id
        text.fontSize = 100
        text.verticalAlignmentMode = .Center
        button.addChild(text)
    }

    func addTo(parentNode: SKNode) -> Button {
        parentNode.addChild(button)
        return self
    }

    func removeThis() {
        button.removeFromParent()
    }
}