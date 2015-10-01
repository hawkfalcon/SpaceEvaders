import SpriteKit

class MainMenuScene: SKScene {
    var viewController: GameViewController?

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        addChild(Utility.skyFullofStars(size.width, height: size.height))
        PopupMenu(size: size, title: "Space Evaders", label: "Play", id: "start").addTo(self)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let touched = self.nodeAtPoint(touch.locationInNode(self))
            guard let name = touched.name else {
                return;
            }
            switch name {
            case "start":
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = scaleMode
                let reveal = SKTransition.doorsOpenVerticalWithDuration(0.5)
                gameScene.viewController = self.viewController
                view?.presentScene(gameScene, transition: reveal)
            case "leaderboard":
                viewController?.openGC()
            default:
                Utility.pressButton(self, touched: touched, score: "-1")
            }
        }
    }
}