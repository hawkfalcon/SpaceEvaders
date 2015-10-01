import SpriteKit

struct Utility {
    static func socialMedia(social: String, score: String) {
        NSNotificationCenter.defaultCenter().postNotificationName("social", object: nil, userInfo: ["score": score, "type": "com.apple.social.\(social)"])
    }

    static func skyFullofStars(width: CGFloat, height: CGFloat) -> SKNode {
        let sky = SKNode()
        for _ in 1 ... 500 {
            let rand = random() % 6
            let star = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: rand, height: rand))
            star.position = CGPoint(x: random() % Int(width), y: random() % Int(height))
            sky.addChild(star)
        }
        return sky
    }

    static func checkPremium() -> Bool {
        return Options.option.get("premium")
    }

    static func pressButton(main: SKScene, touched: SKNode, score: String) {
        let size = main.size
        if let name = touched.name {
            if name.characters.startsWith("option".characters) {
                toggle(name, sprite: touched as! SKSpriteNode, main: main)
            }
            switch name {
            case "purchase":
                NSNotificationCenter.defaultCenter().postNotificationName("premium", object: nil)
            case "restore":
                NSNotificationCenter.defaultCenter().postNotificationName("restore", object: nil)
            case "info":
                Info(size: size).addTo(main)
            case "twitter":
                socialMedia("twitter", score: score)
            case "facebook":
                socialMedia("facebook", score: score)
            case "back":
                let parent = touched.parent
                if parent?.name == "back" {
                    let superp = parent?.parent
                    superp?.removeFromParent()
                } else {
                    touched.removeFromParent()
                    parent?.removeFromParent()
                }
            case "credits":
                let parent = touched.parent
                touched.removeFromParent()
                parent?.removeFromParent()
                let howto = Sprite(named: "howto", x: size.width / 2, y: size.height / 2, size: CGSizeMake(size.width, size.height))
                howto.zPosition = 20
                howto.addTo(main)
            case "howto":
                touched.removeFromParent()
            case "settings":
                let parent = touched.parent! as SKNode
                touched.removeFromParent()
                OptionsMenu(menu: parent, size: size)
            default:
                break
            }
        }
    }

    static func toggle(option: String, sprite: SKSpriteNode, main: SKScene) {
        let opt = option.stringByReplacingOccurrencesOfString("option_", withString: "")
        if opt == "indicators" || opt == "follow" {
            if !Options.option.get("premium") {
                Iapp(size: main.size).addTo(main)
                return
            }
        }
        var next = "on"
        if Options.option.get(opt) {
            next = "off"
        }
        let text = FadeText(x: 0, y: -70, label: "\(opt) \(next)")
        text.addTo(sprite)

        sprite.texture = SKTexture(imageNamed: "\(opt)\(next)")
        Options.option.toggle(opt)
    }
}