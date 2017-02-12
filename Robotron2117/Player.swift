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
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "dude-front-1"), color: UIColor.black, size: CGSize(width: 14*3, height: 24*3))
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        nodeSpeed = 15
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        nodeSpeed = 15
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
    let textures : [[SKTexture]] = {
        var ret : [[SKTexture]] = []
        for set in ["back", "front", "right", "left"] {
            var arr : [SKTexture] = []
            for frame in [ 1, 2, 3, 2 ] {
                arr.append(SKTexture(imageNamed: "dude-\(set)-\(frame)"))
            }
            ret.append(arr)
        }
        return ret
    }()
    
    override func walk() {
        if let ctrl = controller {
            let vec = ctrl.moveVector
            if vec != .zero {
                move(vec)
                nextSprite()
            }
            let shoot = ctrl.shootVector
            if ctrl.trigger, shoot != .zero {
                
            }                
        }
    }
    
    func nextSprite() {
        let set = lastWalkVector.walkDirection.rawValue
        texture = textures[set][step]
        step = step + 1
        if(step >= textures.count) {
            step = 0
        }
    }
}
