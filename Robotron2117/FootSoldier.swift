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
        self.physicsBody?.contactTestBitMask = CollisionType.Player.rawValue
        self.nodeSpeed = 5
        self.walkContext = PursuitContext(self)
        self.spriteTextures = {
            var arr : [SKTexture] = []
            let left = SKTexture(imageNamed: "robo-left")
            let ctr = SKTexture(imageNamed: "robo-center")
            let right = SKTexture(imageNamed: "robo-right")
            
            arr.append(left)
            arr.append(ctr)
            arr.append(right)
            arr.append(ctr)
            
            return arr
        }()
    }

    func shoot() -> Bullet? {
        guard !dead else {
            return nil
        }
        if((arc4random()%20)==0) { // 5% chance
            let shotVector = universe.directionToNearestPlayer(from: self)
            let shot = Bullet.aimedAt(shotVector, by: self)
            shot.physicsBody?.contactTestBitMask = CollisionType.Player.rawValue
            return shot
        }
        return nil
    }
}

