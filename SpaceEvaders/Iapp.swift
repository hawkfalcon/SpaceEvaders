import SpriteKit

class Iapp {
    var iapp: SKSpriteNode

    init(size: CGSize) {
        let x = size.width / 2
        let y = size.height / 2
        iapp = SKSpriteNode(color: UIColor.blackColor(), size: size)
        iapp.position = CGPoint(x: x, y: y)
        iapp.zPosition = 20
        iapp.name = "iapp"
        Button(x: -x / 3, y: -y / 3, width: x / 3, height: y / 3, label: "Back", id: "back").addTo(iapp)
        Button(x: x / 4, y: -y / 3, width: x * 2 / 3, height: y / 3, label: "Purchase", id: "purchase").addTo(iapp)
        addLabels(x, y: y)
        let restore = addText("Restore Purchases", size: 60, x: -25, y: -y / 3 - 250)
        restore.name = "restore"
    }

    func addLabels(x: CGFloat, y: CGFloat) {
        Alien(x: -750, y: 70, startAtTop: true).addTo(iapp)
        let credit = Sprite(named: "credits", x: -750, y: -25).addTo(iapp)
        credit.setScale(0.1)
        //Rocket(x: -550, y: 200).addTo(iapp)
        addText("Purchase Premium!", size: 130, x: 0, y: 400)
        addText("Support the developer :)", size: 80, x: -25, y: 300)
        addText("Premium unlocks two neat features and is the only purchase in this app", size: 50, x: 0, y: 200)
        addText("Switch between follow(default) and inertia modes", size: 60, x: 0, y: 50)
        addText("Add indicators to see where the aliens will spawn next", size: 60, x: 60, y: -50)
    }

    func addText(text: String, size: CGFloat, x: CGFloat, y: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontSize = size
        label.position = CGPointMake(x, y)
        label.fontName = "timeburner"
        label.name = "iapp"
        iapp.addChild(label)
        return label
    }

    func addTo(parentNode: SKScene) -> Iapp {
        parentNode.addChild(iapp)
        return self
    }
}