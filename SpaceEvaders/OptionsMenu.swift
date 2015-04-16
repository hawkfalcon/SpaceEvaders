import SpriteKit

class OptionsMenu {
    init(menu: SKNode, size: CGSize) {
        let options = ["sound", "music", "follow", "indicators"]
        var pos: CGFloat = 51
        for option in options {
            addOption(menu, size: size, option: option, pos: pos)
            pos -= 5
        }
    }
    
    func addOption(menu: SKNode, size: CGSize, option: String, pos: CGFloat) {
        let width = size.width
        let height = size.height
        var isOn = Options.option.get(option) ? "on" : "off"
        let sprite = Sprite(named: "\(option)\(isOn)", x: width*pos/60, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        sprite.name = "option_\(option)"
        NSLog(sprite.name!)
        sprite.addTo(menu)
    }
}
