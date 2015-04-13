import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var viewController:GameViewController?
    let alienSpawnRate = 5
    var isGameOver = false
    var gamePaused = false
    var removeAliens = false
    var scoreboard: Scoreboard!
    var rocket: Rocket!
    var pause: Pause!
    var audioPlayer = AVAudioPlayer()

    override func didMoveToView(view: SKView) {
        if Options.sound() {
           runAction(SKAction.playSoundFileNamed("Start.mp3", waitForCompletion: false))
        }
        backgroundColor = UIColor.blackColor()
        Background(size: size, main: self)
        rocket = Rocket(x: size.width/2, y: size.height/2).addTo(self) as! Rocket
        scoreboard = Scoreboard(x: 50, y: size.height - size.height/5).addTo(self)
        scoreboard.viewController = self.viewController
        pause = Pause(size: size, x: size.width - 50, y: size.height - size.height/6).addTo(self)
        if Options.musicon() {
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
        if touched.name != nil {
            let name = touched.name!
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
            } else if name == "sound" {
                toggleSound(touched as! SKSpriteNode)
            } else if name == "music" {
                toggleMusic(touched as! SKSpriteNode)
            } else if name == "mode" {
                toggleMode(touched as! SKSpriteNode)
            } else if name == "indicator" {
                toggleIndicator(touched as! SKSpriteNode)
            } else {
                tappedButton(name)
            }
        } else {
            currentlyTouching = true
        }
    }
    
    func toggleSound(sprite: SKSpriteNode) {
        var next = "on"
        if Options.sound() {
            next = "off"
        }
        sprite.texture = SKTexture(imageNamed: "sound\(next)")
        Options.toggleSound()
    }
    
    func toggleMusic(sprite: SKSpriteNode) {
        var next = "on"
        if Options.musicon() {
            next = "off"
            audioPlayer.stop()
        } else {
            loopBackground("Chamber-of-Jewels")
            audioPlayer.play()
        }
        sprite.texture = SKTexture(imageNamed: "music\(next)")
        Options.toggleMusic()
    }
    
    func toggleIndicator(sprite: SKSpriteNode) {
        var next = "on"
        if Options.useIndicators() {
            next = "off"
        }
        sprite.texture = SKTexture(imageNamed: "indicator\(next)")
        Options.toggleIndicators()
    }
    
    func toggleMode(sprite: SKSpriteNode) {
        var next = "inertia"
        if Options.getMode() == .Follow {
            next = "follow"
            Options.setMode(.Inertia)
        } else {
            Options.setMode(.Follow)
        }
        sprite.texture = SKTexture(imageNamed: "\(next)mode")
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        currentPosition = touch.locationInNode(self)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if Options.mode == .Follow {
           currentlyTouching = false
        }
    }
    
    func tappedButton(name: String) {
        switch name {
        case "gameover":
            resetGame()
        case "pause":
            pauseGame()
        case "leaderboard":
            viewController?.openGC()
        case "twitter":
            Utility.socialMedia("twitter", score: String(scoreboard.getScore()))
        case "facebook":
            Utility.socialMedia("facebook", score: String(scoreboard.getScore()))
        case "info":
            Info(size: size).addTo(self)
        default:
            currentlyTouching = true
        }
    }
    
    var pausemenu: PopupMenu!
    func pauseGame() {
        if gamePaused {
            if Options.musicon() {
                loopBackground("Chamber-of-Jewels")
                audioPlayer.play()
            }
            gamePaused = false
            speed = 1
            paused = false
            removeDialog()
        } else {
            if !isGameOver {
                if Options.musicon() {
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
           pause = Pause(size: size, x: size.width - 50, y: size.height - size.height/6).addTo(self)
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
            alien.zPosition = 1000
            if Utility.checkPremium() && Options.useIndicators() {
                let arrow = Sprite(named: "credits", x: CGFloat(randomX), y: arrowY, scale: 0.05).addTo(self)
                arrow.zPosition = 20
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
        if Options.sound() {
            runAction(SKAction.playSoundFileNamed("Death.mp3", waitForCompletion: false))
        }
        isGameOver = true
        let exp = Explosion(x: rocket.position.x, y: rocket.position.y).addTo(self) as! Explosion
        if Options.musicon() {
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
                let middle = size.height/2
                let startAtTop = alien.startAtTop.boolValue
                if (!startAtTop && y > middle) || (startAtTop && y < middle) {
                    alien.setDisabled()
                    scoreboard.addScore(1)
                    if Options.sound() {
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
                if Options.sound() {
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
