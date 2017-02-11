//
//  Civilian.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class Civilian: Hittable {
    enum WalkDirection {
        case north
        case south
        case east
        case west
        
        func vector() -> CGVector {
            switch self {
            case .north: return CGVector(dx: 0, dy: -1)
            case .south: return CGVector(dx: 0, dy: 1)
            case .east: return CGVector(dx: 1, dy: 0)
            case .west: return CGVector(dx: -1, dy: 0)
            }
        }
        
        static func random() -> WalkDirection {
            switch (Int(arc4random() % 4)) {
            case 0: return .north
            case 1: return .south
            case 2: return .east
            default: return .west
            }
        }
    }

    var direction = WalkDirection.random()
    var stepCount = 15 + Int(arc4random()%10)
    
    
    override func walk() {
        let vec = direction.vector()
        var pos = self.position
        pos.x = pos.x + (vec.dx * 3)
        pos.y = pos.y + (vec.dy * 3)
        self.position = pos
        stepCount = stepCount - 1
        if(stepCount == 0) {
            newDirection()
        }
    }
    
    func newDirection() {
        stepCount = 10 + Int(arc4random()%20)
        direction = WalkDirection.random()
    }
}
