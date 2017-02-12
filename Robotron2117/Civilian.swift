//
//  Civilian.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Civilian: Hittable {
    var direction = WalkDirection.random()
    var stepCount = 0
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        nodeSpeed = 3
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        nodeSpeed = 3
    }
    
    override func walk() {
        move(direction.vector())

        if(stepCount <= 0) {
            newDirection()
        }
        stepCount = stepCount - 1
    }
    
    func newDirection() {
        stepCount = 10 + Int(arc4random()%20)
        direction = WalkDirection.random()
    }
}
