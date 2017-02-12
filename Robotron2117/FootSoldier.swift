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
            let bullet = Bullet(texture: nil, color: UIColor.red, size: CGSize(width: 10, height: 10))
            bullet.position = self.position
            universe.addChild(bullet)

            let shotVector = universe.shootingDirectionToNearestPlayer(from: self).bulletVector
            
            let bulletAction = SKAction.sequence([
                SKAction.move(by: shotVector, duration: 5.0),
                SKAction.removeFromParent()
                ])
            bullet.run(bulletAction)
            return bullet
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
