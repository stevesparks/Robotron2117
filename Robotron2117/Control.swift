//
//  Control.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import GameController

protocol Control {
    // Vector 1 = movement direction
    // Vector 2 = gun direction
    var valueChangedBlock : ((CGVector, CGVector) -> Void)? { get set }
   
    var moveVector: CGVector { get }
    var shootVector: CGVector { get }
    
    var controller : GCController { get }
    
    var trigger : Bool { get }
    
    // lower number is higher priority
    var priority : Int { get }
            
}


extension CGVector {
    
    // returns a vector where dx = [-1, 0, 1] and dy = [-1, 0, 1]
    var simplifiedVector : CGVector {
        var ret = CGVector(dx: 0, dy: 0)
        let biasX = (fabs(dx) > fabs(dy*2))
        let biasY = (fabs(dy) > fabs(dx*2))
        if(!biasY) {
            switch (dx) {
            case let(me) where 0 > me : ret.dx = -1
            case let(me) where 0 < me : ret.dx = 1
            default: break
            }
        }
        if(!biasX) {
            switch (dy) {
            case let(me) where 0 > me : ret.dy = -1
            case let(me) where 0 < me : ret.dy = 1
            default: break
            }
        }
        return ret
    }
}
