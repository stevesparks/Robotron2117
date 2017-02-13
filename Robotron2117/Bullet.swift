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
    
    static var bullets : [Bullet] = []
    
    static func aimedAt(_ vector: CGVector, by node: GameNode) -> Bullet {
        let size = CGSize(width: 10, height: 10)
        let bullet = Bullet(texture: nil, color: UIColor.red, size: size)
        bullet.position = node.position
        let body = SKPhysicsBody(rectangleOf: size)
        body.categoryBitMask = CollisionType.Bullet.rawValue
        body.collisionBitMask = 0x0
        bullet.physicsBody = body
        node.universe.addChild(bullet)
        bullets.append(bullet)
        let bulletAction = SKAction.sequence([
            SKAction.move(by: vector.bulletVector, duration: 5.0),
            SKAction.removeFromParent()
            ])
        bullet.run(bulletAction, completion: {
            if let idx = bullets.index(of: bullet) {
                bullets.remove(at: idx)
            }
        })
        return bullet
    }

}
