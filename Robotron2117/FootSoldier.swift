//
//  FootSoldier.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/12/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class FootSoldier: Enemy, Shooter {
    func shoot() -> Bullet? {
        if((arc4random()%20)==0) { // 5% chance
            let shotVector = universe.shootingDirectionToNearestPlayer(from: self)
            return Bullet.aimedAt(shotVector, by: self)
        }
        return nil
    }

}

extension CGVector {
    var bulletVector : CGVector {
        let bulletSpeed : CGFloat = 2000.0
        return CGVector(dx: dx*bulletSpeed, dy: dy*bulletSpeed)
    }
}
