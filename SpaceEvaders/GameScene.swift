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

    override func didMove(to view: SKView) {
        if Options.option.get(option: "sound") {
            run(SKAction.playSoundFileNamed("Start.mp3", waitForCompletion: false))
        }
        backgroundColor = UIColor.black
        Background(size: size).addTo(parent: self)
        rocket = Rocket(x: size.width / 2, y: size.height / 2).addToSelf(parent: self) as! Rocket
        scoreboard = Scoreboard(x: 50, y: size.height - size.height / 5).addTo(parentNode: self)
        scoreboard.viewController = self.viewController
        pause = Pause(size: size, x: size.width - 50, y: size.height - size.height / 6).addTo(parent: self)
        if Options.option.get(option: "music") {
            loopBackground(name: "Chamber-of-Jewels")
            audioPlayer.play()
        }
    }

    var currentPosition: CGPoint!
    var currentlyTouching = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        currentPosition = touch.location(in: self)
        let touched = self.atPoint(currentPosition)
        if let name = touched.name {
            switch name {
            case "gameover":
                resetGame()
            case "pause":
                pauseGame()
            case "leaderboard":
                viewController?.openGC()
            case "option_music":
                if Options.option.get(option: "music") {
                    audioPlayer.stop()
                } else {
                    loopBackground(name: "Chamber-of-Jewels")
                    //audioPlayer.play()
                }
            default:
                currentlyTouching = true
            }
            Utility.pressButton(main: self, touched: touched, score: String(scoreboard.getScore()))
        } else {
            currentlyTouching = true
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        currentPosition = touch.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if Options.option.get(option: "follow") {
            currentlyTouching = false
        }
    }

    var pausemenu: PopupMenu!
    func pauseGame() {
        if gamePaused {
            if Options.option.get(option: "music") {
                loopBackground(name: "Chamber-of-Jewels")
                audioPlayer.play()
            }
            gamePaused = false
            //speed = 1
            isPaused = false
            removeDialog()
        } else {
            if !isGameOver {
                if Options.option.get(option: "music") {
                    audioPlayer.stop()
                }
                gamePaused = true
                //speed = 0
                pause.removeThis()
                pausemenu = PopupMenu(size: size, title: "Paused", label: "Continue?", id: "pause")
                pausemenu.addTo(parent: self)
            }
        }
    }

    func removeDialog() {
        if pausemenu != nil {
            pausemenu.removeThis()
            pause = Pause(size: size, x: size.width - 50, y: size.height - size.height / 6).addTo(parent: self)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if !gamePaused {
            if !isGameOver {
                if currentlyTouching {
                    rocket.moveTo(x: currentPosition.x, y: currentPosition.y)
                }
                spawnPowerup()
                enumeratePowerups()
            }
            spawnAliens(startAtTop: true)
            spawnAliens(startAtTop: false)
            enumerateAliens()
        }
    }

    func spawnAliens(startAtTop: Bool) {
        if Int(arc4random()) % 1000 < alienSpawnRate {
            let randomX = 10 + Int(arc4random()) % Int(size.width) - 10
            let startY = startAtTop ? size.height : 0
            let arrowY = startAtTop ? size.height - 200 : 200
            let alien = Alien(x: CGFloat(randomX), y: startY, startAtTop: startAtTop).addToSelf(parent: self)
            alien.zPosition = 2
            if Utility.checkPremium() && Options.option.get(option: "indicators") {
                let arrow = Sprite(named: "credits", x: CGFloat(randomX), y: arrowY, scale: 0.05).addToSelf(parent: self)
                arrow.zPosition = 1
                arrow.run(
                SKAction.sequence([
                        SKAction.fadeAlpha(to: 0.5, duration: 1),
                        SKAction.removeFromParent(),
                ])
                )
            }
        }
    }

    func spawnPowerup() {
        if Int(arc4random()) % 1000 < 1 {
            let x = CGFloat(Int(arc4random()) % Int(size.width))
            let y = CGFloat(Int(arc4random()) % Int(size.height))
            let powerup = Powerup(x: x, y: y).addToSelf(parent: self)
            powerup.run(
            SKAction.sequence([
                    SKAction.fadeAlpha(to: 1, duration: 0.5),
                    SKAction.wait(forDuration: 4.5),
                    SKAction.fadeAlpha(to: 0, duration: 1.0),
                    SKAction.removeFromParent()
            ])
            )
        }
    }

    func gameOver() {
        if Options.option.get(option: "sound") {
            run(SKAction.playSoundFileNamed("Death.mp3", waitForCompletion: false))
        }
        isGameOver = true
        let exp = Explosion(x: rocket.position.x, y: rocket.position.y).addToSelf(parent: self) as! Explosion
        if Options.option.get(option: "music") {
            audioPlayer.stop()
        }
        exp.boom(main: self)
        rocket.removeFromParent()
        pause.removeThis()
        PopupMenu(size: size, title: "Game Over!", label: "Play Again?", id: "gameover").addTo(parent: self)
        if scoreboard.isHighscore() {
            addChild(scoreboard.getHighscoreLabel(size: size))
        }
    }

    func resetGame() {
        let gameScene = GameScene(size: size)
        gameScene.viewController = self.viewController
        gameScene.scaleMode = scaleMode
        let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
        view?.presentScene(gameScene, transition: reveal)
    }

    func enumerateAliens() {
        self.enumerateChildNodes(withName: "alien") {
            node, stop in
            let alien = node as! Alien
            self.alienBrains(alien: alien)
        }
        if (removeAliens) {
            removeAliens = false
        }
    }

    func alienBrains(alien: Alien) {
        let y = alien.position.y
        if !isGameOver {
            if alien.frame.insetBy(dx: 25, dy: 25).intersects(rocket.frame.insetBy(dx: 10, dy: 10)) {
                gameOver()
            }
            //disabled by laser
            if !alien.isDisabled() {
                let middle = size.height / 2
                let startAtTop = alien.startAtTop
                if (!startAtTop! && y > middle) || (startAtTop! && y < middle) {
                    alien.setDisabled()
                    scoreboard.addScore(score: 1)
                    if Options.option.get(option: "sound") {
                        run(SKAction.playSoundFileNamed("Alien_Disable.mp3", waitForCompletion: false))
                    }
                }
            }
            if removeAliens {
                if !alien.isDisabled() {
                    scoreboard.addScore(score: 1)
                }
                alien.removeFromParent()
            }
            alien.moveTo(point: CGPoint(x: rocket.position.x, y: rocket.position.y))
        } else {
            alien.move()
        }
        if y < 0 || y > size.height {
            alien.removeFromParent()
        }
    }

    func enumeratePowerups() {
        self.enumerateChildNodes(withName: "powerup") {
            node, stop in
            if node.frame.insetBy(dx: 5, dy: 5).intersects(self.rocket.frame) {
                if Options.option.get(option: "sound") {
                    self.run(SKAction.playSoundFileNamed("Powerup.mp3", waitForCompletion: false))
                }
                let explosion = Explosion(x: node.position.x, y: node.position.y)
                node.removeFromParent()
                explosion.addTo(parent: self)
                explosion.boom(main: self)
            }
        }
    }

    func loopBackground(name: String) {
        let backgroundSound = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundSound)
        } catch _ as NSError {
            print("Failed to set sound")
        }
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume = 0.4
        audioPlayer.prepareToPlay()
    }
}
