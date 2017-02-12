//
//  Bullet.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

class Bullet: GameNode {
    
    static func aimedAt(_ vector: CGVector, by node: GameNode) -> Bullet {
        let bullet = Bullet(texture: nil, color: UIColor.red, size: CGSize(width: 10, height: 10))
        bullet.position = node.position
        node.universe.addChild(bullet)
        
        let bulletAction = SKAction.sequence([
            SKAction.move(by: vector.bulletVector, duration: 5.0),
            SKAction.removeFromParent()
            ])
        bullet.run(bulletAction)
        return bullet
    }

}
