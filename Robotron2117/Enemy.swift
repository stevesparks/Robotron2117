//
//  Enemy.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Enemy: Hittable {
    
    
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
    
    override func walk() {
        let vec = universe.directionToNearestPlayer(from: self)
        move(vec)
        nextSprite()
    }

    var step = Int(arc4random()%4)
    let textures : [SKTexture] = {
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
    
    func nextSprite() {
        texture = textures[step]
        step = step + 1
        if(step >= textures.count) {
            step = 0
        }
    }
}
