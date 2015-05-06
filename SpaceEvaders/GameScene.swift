import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var viewController: GameViewController?
    let alienSpawnRate = 5
    var isGameOver = false
    var gamePaused = false
    var removeAliens = false
    var scoreboard: Scoreboard!
    var rocket: Rocket!
    var pause: Pause!
    var audioPlayer = AVAudioPlayer()

    override func didMoveToView(view: SKView) {
        if Options.option.get("sound") {
            runAction(SKAction.playSoundFileNamed("Start.mp3", waitForCompletion: false))
        }
        backgroundColor = UIColor.blackColor()
        Background(size: size, main: self)
        rocket = Rocket(x: size.width / 2, y: size.height / 2).addTo(self) as! Rocket
        scoreboard = Scoreboard(x: 50, y: size.height - size.height / 5).addTo(self)
        scoreboard.viewController = self.viewController
        pause = Pause(size: size, x: size.width - 50, y: size.height - size.height / 6).addTo(self)
        if Options.option.get("music") {
            loopBackground("Chamber-of-Jewels")
            audioPlayer.play()
        }
    }

    var currentPosition: CGPoint!
    var currentlyTouching = false

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        currentPosition = touch.locationInNode(self)
        let touched = self.nodeAtPoint(currentPosition)
        if let name = touched.name {
            switch name {
            case "gameover":
                resetGame()
            case "pause":
                pauseGame()
            case "leaderboard":
                viewController?.openGC()
            case "option_music":
                if Options.option.get("music") {
                    audioPlayer.stop()
                } else {
                    loopBackground("Chamber-of-Jewels")
                    audioPlayer.play()
                }
            default:
                currentlyTouching = true
            }
            Utility.pressButton(self, touched: touched, score: String(scoreboard.getScore()))
        } else {
            currentlyTouching = true
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        currentPosition = touch.locationInNode(self)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if Options.option.get("follow") {
            currentlyTouching = false
        }
    }

    var pausemenu: PopupMenu!
    func pauseGame() {
        if gamePaused {
            if Options.option.get("music") {
                loopBackground("Chamber-of-Jewels")
                audioPlayer.play()
            }
            gamePaused = false
            speed = 1
            paused = false
            removeDialog()
        } else {
            if !isGameOver {
                if Options.option.get("music") {
                    audioPlayer.stop()
                }
                gamePaused = true
                speed = 0
                pause.removeThis()
                pausemenu = PopupMenu(size: size, title: "Paused", label: "Continue?", id: "pause")
                pausemenu.addTo(self)
            }
        }
    }

    func removeDialog() {
        if pausemenu != nil {
            pausemenu.removeThis()
            pause = Pause(size: size, x: size.width - 50, y: size.height - size.height / 6).addTo(self)
        }
    }

    override func update(currentTime: CFTimeInterval) {
        if !gamePaused {
            if !isGameOver {
                if currentlyTouching {
                    rocket.moveTo(currentPosition.x, y: currentPosition.y)
                }
                spawnPowerup()
                enumeratePowerups()
            }
            spawnAliens(true)
            spawnAliens(false)
            enumerateAliens()
        }
    }

    func spawnAliens(startAtTop: Bool) {
        if random() % 1000 < alienSpawnRate {
            let randomX = 10 + random() % Int(size.width) - 10
            var startY = startAtTop.boolValue ? size.height : 0
            var arrowY = startAtTop.boolValue ? size.height - 200 : 200
            let alien = Alien(x: CGFloat(randomX), y: startY, startAtTop: startAtTop).addTo(self)
            alien.zPosition = 2
            if Utility.checkPremium() && Options.option.get("indicators") {
                let arrow = Sprite(named: "credits", x: CGFloat(randomX), y: arrowY, scale: 0.05).addTo(self)
                arrow.zPosition = 1
                arrow.runAction(
                SKAction.sequence([
                        SKAction.fadeAlphaTo(0.5, duration: 1),
                        SKAction.removeFromParent(),
                ])
                )
            }
        }
    }

    func spawnPowerup() {
        if random() % 1000 < 1 {
            var x = CGFloat(random() % Int(size.width))
            var y = CGFloat(random() % Int(size.height))
            var powerup = Powerup(x: x, y: y).addTo(self)
            powerup.runAction(
            SKAction.sequence([
                    SKAction.fadeAlphaTo(1, duration: 0.5),
                    SKAction.waitForDuration(4.5),
                    SKAction.fadeAlphaTo(0, duration: 1.0),
                    SKAction.removeFromParent()
            ])
            )
        }
    }

    func gameOver() {
        if Options.option.get("sound") {
            runAction(SKAction.playSoundFileNamed("Death.mp3", waitForCompletion: false))
        }
        isGameOver = true
        let exp = Explosion(x: rocket.position.x, y: rocket.position.y).addTo(self) as! Explosion
        if Options.option.get("music") {
            audioPlayer.stop()
        }
        exp.boom(self)
        rocket.removeFromParent()
        pause.removeThis()
        PopupMenu(size: size, title: "Game Over!", label: "Play Again?", id: "gameover").addTo(self)
        if scoreboard.isHighscore() {
            addChild(scoreboard.getHighscoreLabel(size))
        }
    }

    func resetGame() {
        let gameScene = GameScene(size: size)
        gameScene.viewController = self.viewController
        gameScene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
        view?.presentScene(gameScene, transition: reveal)
    }

    func enumerateAliens() {
        self.enumerateChildNodesWithName("alien") {
            node, stop in
            let alien = node as! Alien
            self.alienBrains(alien)
        }
        if (removeAliens) {
            removeAliens = false
        }
    }

    func alienBrains(alien: Alien) {
        let y = alien.position.y
        if !isGameOver {
            if CGRectIntersectsRect(CGRectInset(alien.frame, 25, 25), CGRectInset(rocket.frame, 10, 10)) {
                gameOver()
            }
            //disabled by laser
            if !alien.isDisabled() {
                let middle = size.height / 2
                let startAtTop = alien.startAtTop.boolValue
                if (!startAtTop && y > middle) || (startAtTop && y < middle) {
                    alien.setDisabled()
                    scoreboard.addScore(1)
                    if Options.option.get("sound") {
                        runAction(SKAction.playSoundFileNamed("Alien_Disable.mp3", waitForCompletion: false))
                    }
                }
            }
            if removeAliens {
                if !alien.isDisabled() {
                    scoreboard.addScore(1)
                }
                alien.removeFromParent()
            }
            alien.moveTo(CGPointMake(rocket.position.x, rocket.position.y))
        } else {
            alien.move()
        }
        if y < 0 || y > size.height {
            alien.removeFromParent()
        }
    }

    func enumeratePowerups() {
        self.enumerateChildNodesWithName("powerup") {
            node, stop in
            if CGRectIntersectsRect(CGRectInset(node.frame, 5, 5), self.rocket.frame) {
                if Options.option.get("sound") {
                    self.runAction(SKAction.playSoundFileNamed("Powerup.mp3", waitForCompletion: false))
                }
                var explosion = Explosion(x: node.position.x, y: node.position.y)
                node.removeFromParent()
                explosion.addTo(self)
                explosion.boom(self)
            }
        }
    }

    func loopBackground(name: String) {
        var backgroundSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: backgroundSound, error: &error)
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume = 0.4
        audioPlayer.prepareToPlay()
    }
}
