import SpriteKit

class Iapp {
    var iapp: SKSpriteNode

    init(size: CGSize) {
        let x = size.width / 2
        let y = size.height / 2
        iapp = SKSpriteNode(color: UIColor.black, size: size)
        iapp.position = CGPoint(x: x, y: y)
        iapp.zPosition = 20
        iapp.name = "iapp"
        Button(x: -x / 3, y: -y / 3, width: x / 3, height: y / 3, label: "Back", id: "back").addTo(parent: iapp)
        Button(x: x / 4, y: -y / 3, width: x * 2 / 3, height: y / 3, label: "Purchase", id: "purchase").addTo(parent: iapp)
        addLabels(x: x, y: y)
        addText(text: "Restore Purchases", size: 60, x: -25, y: -y / 3 - 250, name: "restore")
    }

    func addLabels(x: CGFloat, y: CGFloat) {
        Alien(x: -750, y: 70, startAtTop: true).addTo(parent: iapp)
        let credit = Sprite(named: "credits", x: -750, y: -25).addToSelf(parent: iapp)
        credit.setScale(0.1)
        //Rocket(x: -550, y: 200).addTo(iapp)
        addText(text: "Purchase Premium!", size: 130, x: 0, y: 400)
        addText(text: "Support the developer :)", size: 80, x: -25, y: 300)
        addText(text: "Premium unlocks two neat features and is the only purchase in this app", size: 50, x: 0, y: 200)
        addText(text: "Switch between follow(default) and inertia modes", size: 60, x: 0, y: 50)
        addText(text: "Add indicators to see where the aliens will spawn next", size: 60, x: 60, y: -50)
    }

    func addText(text: String, size: CGFloat, x: CGFloat, y: CGFloat) {
        addText(text: text, size: size, x: x, y: y, name: "iapp")
    }
    
    func addText(text: String, size: CGFloat, x: CGFloat, y: CGFloat, name: String) {
        let label = SKLabelNode(text: text)
        label.fontSize = size
        label.position = CGPoint(x: x, y: y)
        label.fontName = "timeburner"
        label.name = "iapp"
        iapp.addChild(label)
    }

    func addTo(parentNode: SKScene) {
        parentNode.addChild(iapp)
    }
}
