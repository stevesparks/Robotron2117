//
//  Enemy.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Enemy: Hittable {
    var pointValue = 100
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupEnemy()
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupEnemy()
    }
    
    func setupEnemy() {
        let bod = SKPhysicsBody(rectangleOf: size)
        bod.categoryBitMask = CollisionType.Enemy.rawValue
        bod.collisionBitMask = 0x0
        bod.contactTestBitMask = CollisionType.Player.rawValue
        self.physicsBody = bod
    }

}
