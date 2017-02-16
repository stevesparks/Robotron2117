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
        let size = CGSize(width: 5, height: 30)
        let bullet = Bullet(texture: nil, color: UIColor.red, size: size)
        bullet.position = node.position
        let body = SKPhysicsBody(rectangleOf: size)
        body.categoryBitMask = CollisionType.Bullet.rawValue
        body.contactTestBitMask = CollisionType.Player.rawValue | CollisionType.Civilian.rawValue
        body.collisionBitMask = 0x0
        bullet.physicsBody = body
        node.universe.addChild(bullet)
        bullets.append(bullet)
        let bulletAction = SKAction.sequence([
            SKAction.move(by: vector.bulletVector, duration: 2.5),
            SKAction.removeFromParent()
            ])
        bullet.run(bulletAction, completion: {
            if let idx = bullets.index(of: bullet) {
                bullets.remove(at: idx)
            }
        })
        var angle = 0.0
        let sv = vector.simplifiedVector
        
        if sv.dy == sv.dx && sv.dx != 0 {
            angle -= M_PI_4
        } else if sv.dy == -1*sv.dx && sv.dx != 0 {
            angle += M_PI_4
        }
        if(sv.dx != 0 && sv.dy == 0) {
            angle += M_PI_2
        }
        bullet.zRotation = CGFloat(angle)
        return bullet
    }
    
    static func freezeBullets() {
        for bullet in bullets {
            bullet.isPaused = true
        }
    }

    static func releaseBullets() {
        for bullet in bullets {
            bullet.isPaused = false
        }
    }
}

extension CGVector {
    var bulletVector : CGVector {
        let bulletSpeed : CGFloat = 2000.0
        return CGVector(dx: dx*bulletSpeed, dy: dy*bulletSpeed)
    }
}
