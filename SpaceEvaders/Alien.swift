import SpriteKit

class Alien: Sprite {
    var startAtTop: Bool!
    var disabled: Bool = false
    let vel: CGFloat = 4

    init(x: CGFloat, y: CGFloat, startAtTop: Bool) {
        super.init(named: "alien", x: x, y: y)
        self.startAtTop = startAtTop
        self.run(SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 1)))
    }

    func setDisabled() {
        disabled = true
        self.texture = SKTexture(imageNamed: "aliendisabled")
    }

    func isDisabled() -> Bool {
        return disabled
    }

    func moveTo(point: CGPoint) {
        let height = parent?.scene?.size.height
        if height == nil {
            return
        }
        if isDisabled() || position.y > height! - 200 || position.y < 200 {
            move()
        } else {
            var dx = point.x - self.position.x
            var dy = point.y - self.position.y
            let mag = sqrt(dx * dx + dy * dy)
            // Normalize and scale
            dx = dx / mag * vel
            dy = dy / mag * vel
            moveBy(dx: dx, dy: dy)
        }
    }

    func move() {
        //let dy = startAtTop ? -vel : vel
        moveBy(dx: 0, dy: vel)
    }

    func moveBy(dx: CGFloat, dy: CGFloat) {
        self.position = CGPoint(x: self.position.x + dx, y: self.position.y + dy)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
