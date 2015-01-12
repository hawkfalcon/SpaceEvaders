//
//  Shake.swift
//  SpaceEvaders
//
//  Created by Tristen Miller on 1/8/15.
//  Copyright (c) 2015 Tristen Miller. All rights reserved.
//

import SpriteKit

extension SKAction {
    class func shake(initialPosition:CGPoint, duration:Float) -> SKAction {
        var amplitudeX = 10
        var amplitudeY = 10
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actionsArray:[SKAction] = []
        for index in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(random() % amplitudeX) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(random() % amplitudeY) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.moveTo(CGPointMake(newXPos, newYPos), duration: 0.015))
            amplitudeX++; amplitudeY++
        }
        actionsArray.append(SKAction.moveTo(initialPosition, duration: 0.015))
        return SKAction.sequence(actionsArray)
    }
}