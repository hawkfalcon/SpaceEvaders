import SpriteKit

class MainMenuScene: SKScene {
    var viewController: GameViewController?

    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        addChild(Utility.skyFullofStars(width: size.width, height: size.height))
        PopupMenu(size: size, title: "Space Evaders", label: "Play", id: "start").addTo(parent: self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touched = self.atPoint(touch.location(in: self))
            guard let name = touched.name else {
                return;
            }
            switch name {
            case "start":
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = scaleMode
                let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
                gameScene.viewController = self.viewController
                view?.presentScene(gameScene, transition: reveal)
            case "leaderboard":
                viewController?.openGC()
            default:
                Utility.pressButton(main: self, touched: touched, score: "-1")
            }
        }
    }
}
