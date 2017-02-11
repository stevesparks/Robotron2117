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

    override func walk() {
        if let ctrl = controller {
            let vec = ctrl.moveVector
            var pos = self.position
            pos.x = pos.x + (vec.dx * 15)
            pos.y = pos.y + (vec.dy * 15)
            self.position = pos
        }
    }
}
