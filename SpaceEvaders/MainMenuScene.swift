import SpriteKit

class MainMenuScene: SKScene {
    var viewController:GameViewController?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        addChild(Utility.skyFullofStars(size.width, height: size.height))
        PopupMenu(size: size, title: "Space Evaders", label: "Play", id: "start").addTo(self)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touched = self.nodeAtPoint(touch.locationInNode(self))
        if let name = touched.name {
            if name == "back" {
                let parent = touched.parent
                if parent?.name == "back" {
                   let superp = parent?.parent
                   superp?.removeFromParent()
                } else {
                   touched.removeFromParent()
                   parent?.removeFromParent()
                }
            } else if name == "credits" {
                let parent = touched.parent
                touched.removeFromParent()
                parent?.removeFromParent()
                let howto = Sprite(named: "howto", x: size.width/2, y: size.height/2, size: CGSizeMake(size.width, size.height)).addTo(self)
                howto.zPosition = 1004
            } else if name == "howto" {
                touched.removeFromParent()
            } else if name == "settings" {
                let parent = touched.parent! as SKNode
                touched.removeFromParent()
                OptionsMenu(menu: parent, size: size)
            } else if startsWith(name, "option") {
                toggle(name, sprite: touched as! SKSpriteNode)
            } else {
                tappedButton(name)
            }
        }
    }
    
    func toggle(option: String, sprite: SKSpriteNode) {
        let opt = option.stringByReplacingOccurrencesOfString("option_", withString: "")
        NSLog(option)
        var next = "on"
        if Options.option.get(opt) {
            next = "off"
        }
        sprite.texture = SKTexture(imageNamed: "\(opt)\(next)")
        Options.option.toggle(opt)
    }

    func tappedButton(name: String) {
        switch name {
        case "start":
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = scaleMode
            let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
            gameScene.viewController = self.viewController
            view?.presentScene(gameScene, transition: reveal)
        case "leaderboard":
            viewController?.openGC()
        case "info":
            Info(size: size).addTo(self)
        case "twitter":
            Utility.socialMedia("twitter", score: "-1")
        case "facebook":
            Utility.socialMedia("facebook", score: "-1")
        default:
            break
        }
    }
}