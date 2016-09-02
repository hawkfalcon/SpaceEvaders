import SpriteKit
import GameKit

class Scoreboard {

    var viewController: GameViewController?
    let scoreboard = SKLabelNode(text: "Score: 0")
    var score: Int = 0
    var isHighScore = false

    init(x: CGFloat, y: CGFloat) {
        scoreboard.setScale(2.5)
        scoreboard.fontName = "timeburner"
        scoreboard.position = CGPoint(x: x, y: y)
        scoreboard.horizontalAlignmentMode = .left
        scoreboard.zPosition = 10
    }

    func highScore() {
        if score > UserDefaults.standard.integer(forKey: "highscore") {
            UserDefaults.standard.set(score, forKey: "highscore")
            UserDefaults.standard.synchronize()
            isHighScore = true
            GCHelper.sharedInstance.reportLeaderboardIdentifier("leaderBoardID", score: score)
        }
    }

    func addTo(parentNode: GameScene) -> Scoreboard {
        parentNode.addChild(scoreboard)
        return self
    }

    func addScore(score: Int) {
        self.score += score
        scoreboard.text = "Score: \(self.score)"
        highScore()
    }

    func getScore() -> Int {
        return score
    }

    func isHighscore() -> Bool {
        return isHighScore
    }

    func getHighscoreLabel(size: CGSize) -> SKLabelNode {
        let highscore = SKLabelNode(text: "High Score!")
        highscore.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        highscore.fontColor = UIColor.red
        highscore.fontSize = 80
        highscore.fontName = "timeburner"
        highscore.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 0.3), SKAction.fadeOut(withDuration: 0.3)])))
        return highscore
    }
}
