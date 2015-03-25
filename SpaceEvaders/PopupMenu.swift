import SpriteKit

class PopupMenu {
    var menu: SKNode
    var isOn = Utility.sound() ? "on" : "off"
    var isOnM = Utility.musicon() ? "on" : "off"

    init(size: CGSize, title: String, label: String, id: String) {
        let width = size.width
        let height = size.height
        self.menu = SKNode()
        Button(x: width/2, y: height/3, width: width/3, height: height/6, label: label, id: id).addTo(menu)
        Sprite(named: "twitter", x: 3*width/4, y: height/3 + height/26, scale: 0.1).addTo(menu)
        Sprite(named: "facebook", x: 3*width/4, y: height/3 - height/26, scale: 0.1).addTo(menu)
        Sprite(named: "info", x: 14*width/15, y: 4*height/5, size: CGSizeMake(height/12, height/12)).addTo(menu)
        let sound = Sprite(named: "sound\(isOn)", x: 51*width/60, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        let music = Sprite(named: "music\(isOnM)", x: 23*width/30, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        music.name = "music"
        sound.name = "sound"
        music.addTo(menu)
        sound.addTo(menu)
        Sprite(named: "leaderboard", x: width/4, y: height/3, size: CGSizeMake(height/6, height/6)).addTo(menu)
        addTitle(title, position: CGPointMake(width/2, 3*height/5))
    }
    
    func addTitle(title: String, position: CGPoint) {
        let node = SKLabelNode(text: title)
        node.fontName = "timeburner"
        node.fontSize = 200
        node.color = UIColor.whiteColor()
        node.position = position
        menu.addChild(node)
    }
    
    func addTo(parentNode: SKScene) -> PopupMenu {
        parentNode.addChild(menu)
        return self
    }
    
    func removeThis() {
        menu.removeFromParent()
    }
}