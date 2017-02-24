//
//  FootSoldier.swift
//  Nerdotron2117
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
        self.spriteTextures = FootSoldier.soldierTextures
    }

    func shoot() -> Bullet? {
        guard !dead else {
            return nil
        }
        if((arc4random()%40)==0) { // 5% chance
            let shotVector = universe.directionToNearestPlayer(from: self)
            let shot = Bullet.aimedAt(shotVector, by: self)
            shot.physicsBody?.contactTestBitMask = CollisionType.Player.rawValue | CollisionType.Civilian.rawValue
            return shot
        }
        return nil
    }

    static var soldierTextures : [SKTexture] = {
        return [SKTexture(imageNamed: "robo-left"),
                SKTexture(imageNamed: "robo-center"),
                SKTexture(imageNamed: "robo-right"),
                SKTexture(imageNamed: "robo-center")]
    }()
    
}

