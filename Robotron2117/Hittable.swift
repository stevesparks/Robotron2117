//
//  Hittable.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

class Hittable: SKSpriteNode {
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupHittable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHittable()
    }
    
    func setupHittable() {
        self.physicsBody?.categoryBitMask = 0x01
        
    }
    
    
    func walk() {
        
    }
}
