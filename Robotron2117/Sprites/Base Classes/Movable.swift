//
//  Movable.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/12/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Movable : GameNode {
    var previousPosition : CGPoint = .zero

    var dead = false
    var speedModifier : CGFloat = 1.0
    
    enum WalkDirection : String {
        case north = "north"
        case south = "south"
        case east = "east"
        case west = "west"
        
        func vector() -> CGVector {
            switch self {
            case .north: return CGVector(dx: 0, dy: 1)
            case .south: return CGVector(dx: 0, dy: -1)
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
        
        func reverse() -> WalkDirection {
            switch self {
            case .north: return .south
            case .south: return .north
            case .east: return .west
            case .west: return .east
            }
        }
        
        func spriteSet() -> String {
            switch self {
            case .north: return "back"
            case .south: return "front"
            case .east: return "right"
            case .west: return "left"
            }
        }
    }
    
    var nodeSpeed : CGFloat = 1.0
    var lastWalkVector : CGVector = .zero

    var direction : WalkDirection = .south {
        didSet {
            didChangeDirection(direction)
        }
    }

    public func walk() {  } // subclasses override
    
    public func didChangeDirection(_ direction: Movable.WalkDirection) {
        nextSprite()
    }
    
    // called when walker hits a wall
    public func revert(_ obstacle: SKSpriteNode) {
        self.position = self.previousPosition
    }
    
    public func move(_ direction : CGVector) -> Bool {
        guard !dead else {
            return false
        }
        var vec = direction
        vec.dx *= (nodeSpeed * speedModifier)
        vec.dy *= (nodeSpeed * speedModifier)
        var pos = position
        pos.x = pos.x + vec.dx
        pos.y = pos.y + vec.dy

        lastWalkVector = vec
        let originalPosition = position
        position = pos
        if !universe.playfieldFrame.contains(frame) {
            position = originalPosition
            return false
        } else {
            previousPosition = originalPosition
        }

        nextSprite()
        return true
    }



    func isOnScreen(_ pos : CGPoint) -> Bool {
        return universe.playfieldFrame.contains(pos)
    }

    
    var spriteStep = Int(arc4random()%4)
    var spriteTextures : [SKTexture] = []
    
    func nextSprite() {
        guard spriteTextures.count >= 2 else {
            return
        }
        
        texture = spriteTextures[spriteStep]
        if let sz = texture?.size() {
            self.size = CGSize(width: sz.width*3, height: sz.height*3)
        }
        
        spriteStep = (spriteStep + 1) % spriteTextures.count
    }
}


extension CGVector {
    var walkDirection : Movable.WalkDirection {
        switch (dx, dy) {
        case let (x, y) where y < 0 && fabs(y)>fabs(x): return .south
        case let (x, y) where x > 0 && fabs(y)<fabs(x): return .east
        case let (x, y) where x < 0 && fabs(y)<fabs(x): return .west
        case let (x, y) where y > 0 && fabs(y)>fabs(x): return .north
        default: return .south
        }
    }
}

