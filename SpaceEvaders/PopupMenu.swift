import SpriteKit

class PopupMenu {
    var menu: SKNode

    init(size: CGSize, title: String, label: String, id: String) {
        let width = size.width
        let height = size.height
        self.menu = SKNode()
        menu.zPosition = 5
        Button(x: width / 2, y: height / 3, width: width / 3, height: height / 6, label: label, id: id).addTo(parent: menu)
        Sprite(named: "twitter", x: 3 * width / 4, y: height / 3 + height / 26, scale: 0.1).addTo(parent: menu)
        Sprite(named: "facebook", x: 3 * width / 4, y: height / 3 - height / 26, scale: 0.1).addTo(parent: menu)
        Sprite(named: "info", x: 14 * width / 15, y: 4 * height / 5, size: CGSize(width: height / 12, height: height / 12)).addTo(parent: menu)
        let options = Sprite(named: "settings", x: 51 * width / 60, y: 4 * height / 5, size: CGSize(width: height / 12, height: height / 12))
        options.addTo(parent: menu)
        Sprite(named: "leaderboard", x: width / 4, y: height / 3, size: CGSize(width: height / 6, height: height / 6)).addTo(parent: menu)
        addTitle(title: title, position: CGPoint(x: width / 2, y: 3 * height / 5))
    }

    func addTitle(title: String, position: CGPoint) {
        let node = SKLabelNode(text: title)
        node.fontName = "timeburner"
        node.fontSize = 200
        node.color = UIColor.white
        node.position = position
        menu.addChild(node)
    }

    func addTo(parent: SKScene) {
        parent.addChild(menu)
    }

    func removeThis() {
        menu.removeFromParent()
    }
}
