//
//  Player.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/10/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

enum PlayerNumber {
    case one
    case two
}

class Player: Hittable {
    var shotCountdown = 0
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "dude-front-1"), color: UIColor.black, size: CGSize(width: 14*3, height: 24*3))
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupPlayer()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupPlayer()
    }
    
    func setupPlayer() {
        let bod = SKPhysicsBody(rectangleOf: size)
        bod.collisionBitMask = 0x0
        bod.contactTestBitMask = CollisionType.Enemy.rawValue
        bod.categoryBitMask = CollisionType.Player.rawValue
        self.physicsBody = bod
        nodeSpeed = 10
    }

    var controller : Control? {
        willSet {
            if var ctrl = controller {
                ctrl.valueChangedBlock = nil
            }
        }
        didSet {
            if var ctrl = controller {
                ctrl.valueChangedBlock = { move, shoot in
                }
            }
        }
    }
    
    var step = Int(arc4random()%4)
    
    static let textures : [String : [SKTexture]] = {
        var ret : [String : [SKTexture]] = [:]
        for set in ["back", "front", "right", "left"] {
            var arr : [SKTexture] = []
            for frame in [ 1, 2, 3, 2 ] {
                arr.append(SKTexture(imageNamed: "dude-\(set)-\(frame)"))
            }
            ret[set] = arr
        }
        return ret
    }()

    override func walk() {
        if let ctrl = controller {
            let vec = ctrl.moveVector
            if vec != .zero {
                _ = move(vec)
                nextSprite()
            }
//        } else {
//            print("No controller")
        }
    }
    
    func nextSprite() {
        let set = lastWalkVector.walkDirection.spriteView()
        texture = Player.textures[set]![step]
        step = step + 1
        if(step >= Player.textures.count) {
            step = 0
        }
    }
}

extension Player : Shooter {
    func shoot()  -> Bullet? {
        if(shotCountdown > 0) {
            shotCountdown -= 1
            return nil
        }
        if let ctrl = controller {
            let shoot = ctrl.shootVector
            if shoot != .zero && ctrl.trigger {
                shotCountdown = 5
                let shot = Bullet.aimedAt(shoot, by: self)
                shot.color = UIColor.green
                shot.physicsBody?.contactTestBitMask = CollisionType.Enemy.rawValue 
                return shot
            }
        }
        return nil
    }
}

