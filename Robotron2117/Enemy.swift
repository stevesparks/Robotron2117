//
//  Enemy.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Enemy: Hittable {
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "robo-center"), color: UIColor.black, size: CGSize(width: 18*3, height: 28*3))
        self.nodeSpeed = 5
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
