//
//  FootSoldier.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/12/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class FootSoldier: Enemy, Shooter {
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "robo-center"), color: UIColor.black, size: CGSize(width: 18*3, height: 28*3))
        self.nodeSpeed = 5
    }

    func shoot() -> Bullet? {
        guard !dead else {
            return nil
        }
        if((arc4random()%20)==0) { // 5% chance
            let shotVector = universe.shootingDirectionToNearestPlayer(from: self)
            let shot = Bullet.aimedAt(shotVector, by: self)
            shot.physicsBody?.collisionBitMask = CollisionType.Player.rawValue
            return shot
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
