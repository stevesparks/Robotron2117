//
//  Control.swift
//  Nerdotron2117
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
    
    var buttonAPressed : Bool { get }
    
    var controller : GCController { get }
    
    var trigger : Bool { get }
    
    // lower number is higher priority
    var priority : Int { get }
            
}


extension CGVector {
    // returns a vector where dx = [-1, 0, 1] and dy = [-1, 0, 1]
    var simplifiedVector : CGVector {
        func sign(_ val: CGFloat) -> CGFloat {
            switch (val) {
            case let(val) where 0 > val : return -1
            case let(val) where 0 < val : return 1
            default: return 0
            }
        }
        var ret = CGVector(dx: 0, dy: 0)
        let isHoriz = (fabs(dx) > fabs(dy*2))
        if(!isHoriz) {
            ret.dy = sign(dy)
        }
        let isVert = (fabs(dy) > fabs(dx*2))
        if(!isVert) {
            ret.dx = sign(dx)
        }
        return ret
    }
}
