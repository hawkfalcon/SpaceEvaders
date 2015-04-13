struct Options {
    enum Mode: String {
        case Follow = "follow"
        case Inertia = "inertia"
    }
    
    static var mode = Mode.Follow
    static var sounds = true
    static var music = true
    static var premium = true
    static var indicators = false
    
    static func sound() -> Bool {
        return sounds
    }
    
    static func toggleSound() {
        sounds = !sounds
    }
    
    static func setSound(val: Bool) {
        sounds = val
    }
    
    static func musicon() -> Bool {
        return music
    }
    
    static func toggleMusic() {
        music = !music
    }
    
    static func setMusic(val: Bool) {
        music = val
    }
    
    static func isPremium() -> Bool {
        return premium
    }
    
    static func setPremium() {
        premium = true
    }
    
    static func getMode() -> Mode {
        return mode
    }
    
    static func setMode(mode: Mode) {
        self.mode = mode
    }
    
    static func useIndicators() -> Bool {
        return indicators
    }
    
    static func toggleIndicators() {
        indicators = !indicators
    }
    
    static func setIndicator(val: Bool) {
        indicators = val
    }
}
