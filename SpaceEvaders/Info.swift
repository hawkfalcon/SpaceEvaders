import SpriteKit

class Info {
    var info: SKSpriteNode
    
    init(size: CGSize) {
        let x = size.width/2
        let y = size.height/2
        info = SKSpriteNode(color: UIColor.blackColor(), size: size)
        info.position = CGPoint(x: x, y: y)
        info.zPosition = 7
        info.name = "howto"
        let bg = Background(size: size, main: info)
        bg.background.name = "howto"
        bg.background.zPosition = 6
        bg.background.position = CGPoint(x: -x, y: -y)
        let bt = Button(x: 0, y: -y/3, width: x*2/3, height: y/3, label: "Back", id: "back").addTo(info)
        bt.button.zPosition = 10
        addPause(x, y: y)
    }
    
    func addPause(x: CGFloat, y: CGFloat) {
        let alien = Alien(x: -650, y: -200, startAtTop: true)
        alien.addTo(info)
        alien.setDisabled()
        Alien(x: 150, y: 200, startAtTop: true).addTo(info)
        Rocket(x: -550, y: 200).addTo(info)
        let pw = Powerup(x: x - 350, y: -200).addTo(info)
        pw.alpha = 1
        
        addText("[Avoid the aliens]", size: 80, x: 150, y: 100)
        addText("[Rocket follows finger]", size: 80, x: -550, y: 100)
        addText("CREDITS", size: 80, x: x - 300, y: y - 550)
        addText("HOW TO PLAY", size: 130, x: 0, y: y - 400)
        addText("↑ this deactivates aliens", size: 60, x: -650, y: -100)
        addText("(can still kill you)", size: 60, x: -650, y: -350)
        addText("Powerups destroy", size: 60, x: x - 350, y: -100)
        addText("all aliens", size: 60, x: x - 350, y: -350)
        let credit = Sprite(named: "credits", x: x - 300, y: y - 400).addTo(info)
        credit.setScale(0.2)
        credit.zPosition = 10
    }
    
    func addText(text: String, size: CGFloat, x: CGFloat, y: CGFloat) {
        let label = SKLabelNode(text: text)
        label.fontSize = size
        label.position = CGPointMake(x, y)
        label.fontName = "timeburner"
        label.name = "howto"
        info.addChild(label)
    }
    
    func addTo(parentNode: SKScene) -> Info {
        parentNode.addChild(info)
        return self
    }
}