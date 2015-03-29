import SpriteKit

class OptionsMenu {
    var isOn = Options.sound() ? "on" : "off"
    var isOnM = Options.musicon() ? "on" : "off"
    
    init(menu: SKNode, size: CGSize) {
        let width = size.width
        let height = size.height
        let sound = Sprite(named: "sound\(isOn)", x: 51*width/60, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        let music = Sprite(named: "music\(isOnM)", x: 23*width/30, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        music.name = "music"
        sound.name = "sound"
        music.addTo(menu)
        sound.addTo(menu)
    }
}