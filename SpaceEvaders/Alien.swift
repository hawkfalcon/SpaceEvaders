import SpriteKit

class Alien : Sprite {
    var startAtTop: Bool!
    var disabled: Bool = false
    let vel: CGFloat = 4
    
    init(x: CGFloat, y: CGFloat, startAtTop:Bool) {
        super.init(named: "alien", x: x, y: y)
        self.startAtTop = startAtTop
        self.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(1, duration: 1)))
    }
    
    func setDisabled() {
        disabled = true
        self.texture = SKTexture(imageNamed: "aliendisabled")
    }
    
    func isDisabled() -> Bool {
        return disabled
    }

    func moveTo(point: CGPoint) {
        if isDisabled() {
            move()
        } else {
            var dx = point.x - self.position.x
            var dy = point.y - self.position.y
            let mag = sqrt(dx*dx+dy*dy)
            // Normalize and scale
            dx = dx/mag * vel
            dy = dy/mag * vel
            moveBy(dx, dy: dy)
        }
    }
    
    func move() {
        moveBy(0, dy: startAtTop.boolValue ? -vel : vel)
    }
    
    func moveBy(dx: CGFloat, dy: CGFloat) {
        self.position = CGPointMake(self.position.x+dx, self.position.y+dy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}