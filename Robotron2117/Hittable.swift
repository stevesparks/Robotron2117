//
//  Hittable.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

class Hittable: GameNode {
    enum WalkDirection : Int {
        case north = 0
        case south = 1
        case east = 2
        case west = 3
        
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
    
    var nodeSpeed : CGFloat = 1.0
    
    var lastWalkVector : CGVector = .zero
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupHittable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHittable()
    }
    
    func setupHittable() {
        self.physicsBody?.categoryBitMask = 0x01
        
    }
    
    
    func walk() {
        
    }
    
    func move(_ direction : CGVector) {
        var vec = direction
        vec.dx *= nodeSpeed
        vec.dy *= nodeSpeed
        var pos = position
        pos.x = pos.x + vec.dx
        pos.y = pos.y + vec.dy
        lastWalkVector = vec
        position = pos
    }
}

extension CGVector {
    var walkDirection : Hittable.WalkDirection {
        switch (dx, dy) {
        case let (x, y) where y < 0 && fabs(y)>fabs(x): return .south
        case let (x, y) where x > 0 && fabs(y)<fabs(x): return .east
        case let (x, y) where x < 0 && fabs(y)<fabs(x): return .west
        case let (x, y) where y > 0 && fabs(y)>fabs(x): return .north
        default: return .south
        }
    }
}
