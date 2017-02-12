//
//  Civilian.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Civilian: Hittable {
    enum CivilianType : String {
        case lady = "lady"
        case man = "man"
        case boy = "boy"
    }
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "lady-front-1"), color: UIColor.green, size: CGSize(width: 14*3, height: 28*3))
        switch (arc4random()%3) {
        case 0:
            self.type = .lady
        case 1:
            self.type = .man
        default:
            self.type = .boy
        }
    }
    
    convenience init(_ type: CivilianType) {
        self.init(texture: nil, color: UIColor.green, size: CGSize(width: 14*3, height: 28*3))
        self.type = type        
    }
    
    var type : CivilianType = .lady
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
  
    var walkDelay = 0
    override func walk() {
        if(walkDelay == 0) {
            move(direction.vector())
            
            if(stepCount <= 0) {
                newDirection()
            }
            stepCount = stepCount - 1
            nextSprite()
        }
        walkDelay += 1
        if walkDelay > 3 {
            walkDelay = 0
        }
    }
    
    func newDirection() {
        stepCount = 10 + Int(arc4random()%20)
        direction = WalkDirection.random()
    }
    
    var step = Int(arc4random()%4)
    lazy var textures : [[SKTexture]] = {
        var ret : [[SKTexture]] = []
        for set in ["back", "front", "right", "left"] {
            var arr : [SKTexture] = []
            for frame in [ 1, 2, 3, 2 ] {
                arr.append(SKTexture(imageNamed: "\(self.type.rawValue)-\(set)-\(frame)"))
            }
            ret.append(arr)
        }
        return ret
    }()

    func nextSprite() {
        let set = lastWalkVector.walkDirection.rawValue
        texture = textures[set][step]
        step = step + 1
        if(step >= textures[set].count) {
            step = 0
        }
    }

}
