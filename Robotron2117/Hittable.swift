//
//  Hittable.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

class Hittable: Movable {
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupHittable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHittable()
    }
    
    func setupHittable() {
        self.physicsBody?.categoryBitMask = CollisionType.Player.rawValue
        self.physicsBody?.contactTestBitMask = CollisionType.Bullet.rawValue | CollisionType.Wall.rawValue
        
    }
}

