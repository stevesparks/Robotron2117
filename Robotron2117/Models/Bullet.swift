//
//  Bullet.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit
import AVKit

class Bullet: GameNode {
    static var bullets : [Bullet] = []
    static func aimedAt(_ vector: CGVector, by shooter: GameNode) -> Bullet {
        let size = CGSize(width: 5, height: 30)

        // Put a bullet on the screen
        let bullet = Bullet(texture: nil, color: UIColor.red, size: size)
        bullet.position = shooter.position
        bullet.rotateTo(vector)
        bullets.append(bullet)
        shooter.universe.addChild(bullet)

        // give it properties for letting us know when it hits
        let body = SKPhysicsBody(rectangleOf: size)
        body.categoryBitMask = CollisionType.Bullet.rawValue
        if let _ = shooter as? Player {
            body.contactTestBitMask = CollisionType.Enemy.rawValue | CollisionType.Civilian.rawValue
        } else {
            body.contactTestBitMask = CollisionType.Player.rawValue | CollisionType.Civilian.rawValue
        }
        body.collisionBitMask = 0x0
        bullet.physicsBody = body

        // and shoot it!
        let bulletAction = SKAction.sequence([
            SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false),
            SKAction.move(by: vector.bulletVector, duration: 2.5),
            SKAction.removeFromParent()
            ])
        bullet.run(bulletAction, completion: {
            if let idx = bullets.index(of: bullet) {
                bullets.remove(at: idx)
            }
        })
        return bullet
    }

    func rotateTo(_ vector: CGVector) {
        var angle = 0.0
        let sv = vector.simplifiedVector

        if sv.dy == sv.dx && sv.dx != 0 { // X = Y
            angle -= .pi / 4
        } else if sv.dy == -1*sv.dx && sv.dx != 0 { // X = -Y
            angle += .pi / 4
        }
        if(sv.dx != 0 && sv.dy == 0) { // horizontal (Y = 0)
            angle += .pi / 2
        }
        zRotation = CGFloat(angle)
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
