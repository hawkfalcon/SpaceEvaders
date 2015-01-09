//
//  Powerup.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/2/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

class Powerup : Sprite {
    init(x: CGFloat, y: CGFloat) {
        super.init(imageNamed: "powerup", name: "pu", x: x, y: y)
    }
}
