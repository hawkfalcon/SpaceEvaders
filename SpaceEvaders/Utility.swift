import SpriteKit

struct Utility {
    static func socialMedia(social: String, score: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "social"), object: nil, userInfo: ["score": score, "type": "com.apple.social.\(social)"])
    }

    static func skyFullofStars(width: CGFloat, height: CGFloat) -> SKNode {
        let sky = SKNode()
        for _ in 1 ... 500 {
            let rand = Int(arc4random()) % 6
            let star = SKSpriteNode(color: UIColor.white, size: CGSize(width: rand, height: rand))
            star.position = CGPoint(x: Int(arc4random()) % Int(width), y: Int(arc4random()) % Int(height))
            sky.addChild(star)
        }
        return sky
    }

    static func checkPremium() -> Bool {
        return Options.option.get(option: "premium")
    }

    static func pressButton(main: SKScene, touched: SKNode, score: String) {
        let size = main.size
        if let name = touched.name {
            if name.starts(with: "option") {
                toggle(option: name, sprite: touched as! SKSpriteNode, main: main)
            }
            switch name {
            case "purchase":
                NotificationCenter.default.post(name: Notification.Name(rawValue: "premium"), object: nil)
            case "restore":
                NotificationCenter.default.post(name: Notification.Name(rawValue: "restore"), object: nil)
            case "info":
                Info(size: size).addTo(parent: main)
            case "twitter":
                socialMedia(social: "twitter", score: score)
            case "facebook":
                socialMedia(social: "facebook", score: score)
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
                let howto = Sprite(named: "howto", x: size.width / 2, y: size.height / 2, size: CGSize(width: size.width, height: size.height))
                howto.zPosition = 20
                howto.addTo(parent: main)
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
        let opt = option.replacingOccurrences(of: "option_", with: "")
        if opt == "indicators" || opt == "follow" {
            if !Options.option.get(option: "premium") {
                Iapp(size: main.size).addTo(parentNode: main)
                return
            }
        }
        var next = "on"
        if Options.option.get(option: opt) {
            next = "off"
        }
        let text = FadeText(x: 0, y: -70, label: "\(opt) \(next)")
        text.addTo(parent: sprite)

        sprite.texture = SKTexture(imageNamed: "\(opt)\(next)")
        Options.option.toggle(option: opt)
    }
}
