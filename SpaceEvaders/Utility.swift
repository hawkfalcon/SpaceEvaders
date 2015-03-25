import Foundation
import SpriteKit

struct Utility {
    static var sounds = true
    static var music = true

    static func sound() -> Bool {
        return sounds
    }
    
    static func toggleSound() {
        sounds = !sounds
    }
    
    static func setSound(val: Bool) {
       sounds = val
    }
    
    static func musicon() -> Bool {
        return music
    }
    
    static func toggleMusic() {
        music = !music
    }
    
    static func setMusic(val: Bool) {
        music = val
    }
    
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
}