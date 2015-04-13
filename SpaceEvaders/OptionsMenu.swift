import SpriteKit

class OptionsMenu {
    var isOn = Options.sound() ? "on" : "off"
    var isOnM = Options.musicon() ? "on" : "off"
    var indicator = Options.useIndicators() ? "on" : "off"
    var modeImg = Options.getMode() == .Inertia ? "follow" : "inertia"
    
    
    init(menu: SKNode, size: CGSize) {
        let width = size.width
        let height = size.height
        let sound = Sprite(named: "sound\(isOn)", x: 51*width/60, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        let music = Sprite(named: "music\(isOnM)", x: 23*width/30, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        let mode = Sprite(named: "\(modeImg)mode", x: 41*width/60, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        let indicators = Sprite(named: "indicator\(indicator)", x: 36*width/60, y: 4*height/5, size: CGSizeMake(height/12, height/12))
        music.name = "music"
        sound.name = "sound"
        mode.name = "mode"
        indicators.name = "indicator"
        music.addTo(menu)
        sound.addTo(menu)
        indicators.addTo(menu)
        mode.addTo(menu)
    }
}