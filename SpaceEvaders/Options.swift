class Options {
    class var option: Options {
        return _Options
    }
    
    var options:[String: Bool]
    
    init(options:[String: Bool]) {
        self.options = options
    }
    
    func getOptions() -> [String: Bool] {
        return self.options
    }
    
    func setOptions(options: [String: Bool]) {
        self.options = options
    }
    
    func get(option: String) -> Bool {
        return options[option]!
    }
    
    func toggle(option: String) {
        if let opt = options[option] {
            options[option] = !opt
        }
    }
    
    func set(option: String, val: Bool) {
        options[option] = val
    }
}

private let _Options = Options(options:
    ["premium": false, "sound":true, "music":true, "indicators":false, "follow":true]
)
