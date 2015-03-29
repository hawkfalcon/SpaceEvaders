import SpriteKit

struct Utility {
    static func socialMedia(social:String, score:String) {
        NSNotificationCenter.defaultCenter().postNotificationName("social", object: nil, userInfo:["score":score, "type" : "com.apple.social.\(social)"])
    }
    
    static func skyFullofStars(width: CGFloat, height: CGFloat) -> SKNode {
        let sky = SKNode()
        for _ in 1...500 {
            let rand = random() % 6
            let star = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: rand, height: rand))
            star.position = CGPoint(x: random() % Int(width), y: random() % Int(height))
            sky.addChild(star)
        }
        return sky
    }
    
    static func checkPremium() -> Bool {
        return Options.isPremium()
    }
}