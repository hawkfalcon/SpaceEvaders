import SpriteKit

class Info {
    var info: SKSpriteNode

    init(size: CGSize) {
        let x = size.width / 2
        let y = size.height / 2
        info = SKSpriteNode(color: UIColor.black, size: size)
        info.position = CGPoint(x: x, y: y)
        info.zPosition = 7
        info.name = "howto"
        let bg = Background(size: size).addToSelf(parent: info);
        bg.name = "howto"
        bg.zPosition = 6
        bg.position = CGPoint(x: -x, y: -y)
        
        let bt = Button(x: 0, y: -y / 3, width: x * 2 / 3, height: y / 3, label: "Back", id: "back").addToSelf(parent: info)
        bt.zPosition = 10
        addPause(x: x, y: y)
    }

    func addPause(x: CGFloat, y: CGFloat) {
        let alien = Alien(x: -650, y: -200, startAtTop: true)
        alien.addTo(parent: info)
        alien.setDisabled()
        Alien(x: 150, y: 200, startAtTop: true).addTo(parent: info)
        Rocket(x: -550, y: 200).addTo(parent: info)
        let pw = Powerup(x: x - 350, y: -200).addToSelf(parent: info)
        pw.alpha = 1

        addText(text: "[Avoid the aliens]", size: 80, x: 150, y: 100)
        addText(text: "[Rocket follows finger]", size: 80, x: -550, y: 100)
        addText(text: "CREDITS", size: 80, x: x - 300, y: y - 550)
        addText(text: "HOW TO PLAY", size: 130, x: 0, y: y - 400)
        addText(text: "↑ this deactivates aliens", size: 60, x: -650, y: -100)
        addText(text: "(can still kill you)", size: 60, x: -650, y: -350)
        addText(text: "Powerups destroy", size: 60, x: x - 350, y: -100)
        addText(text: "all aliens", size: 60, x: x - 350, y: -350)
        let credit = Sprite(named: "credits", x: x - 300, y: y - 400).addToSelf(parent: info)
        credit.setScale(0.2)
        credit.zPosition = 10
    }

    func addText(text: String, size: CGFloat, x: CGFloat, y: CGFloat) {
        let label = SKLabelNode(text: text)
        label.fontSize = size
        label.position = CGPoint(x: x, y: y)
        label.fontName = "timeburner"
        label.name = "howto"
        info.addChild(label)
    }

    func addTo(parent: SKScene) {
        parent.addChild(info)
    }
}
