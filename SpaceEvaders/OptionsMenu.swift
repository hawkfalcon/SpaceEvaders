import SpriteKit

class OptionsMenu {
    @discardableResult
    init(menu: SKNode, size: CGSize) {
        let options = ["sound", "music", "follow", "indicators"]
        var pos: CGFloat = 51
        for option in options {
            addOption(menu: menu, size: size, option: option, pos: pos)
            pos -= 5
        }
    }

    func addOption(menu: SKNode, size: CGSize, option: String, pos: CGFloat) {
        let height = size.height
        let isOn = Options.option.get(option: option) ? "on" : "off"
        let sprite = Sprite(named: "\(option)\(isOn)", x: size.width * pos / 60, y: 4 * height / 5, size: CGSize(width: height / 12, height: height / 12))
        sprite.name = "option_\(option)"
        sprite.addTo(parent: menu)
    }
}
