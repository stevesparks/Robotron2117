//
//  GameUniverse+Targeting.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/13/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

// MARK: Targeting
extension GameUniverse {
    
    func nearestPlayer(to node: GameNode) -> Player {
        let pos = node.position
        let p1Dist = playerOne.position.distance(to: pos)
        let p2Dist = playerTwo.position.distance(to: pos)
        if(p1Dist < p2Dist) {
            return playerOne
        } else {
            return playerTwo
        }
    }
    
    func directionToNearestPlayer(from node: GameNode) -> CGVector {
        let c1 = node.position
        let player = nearestPlayer(to: node)
        var ret = CGVector(dx: 0, dy: 0)
        
        switch (player.position.x, c1.x) {
        case let(them, me) where them < me: ret.dx = -1
        case let(them, me) where them > me: ret.dx = 1
        default: break
        }
        switch (player.position.y, c1.y) {
        case let(them, me) where them < me: ret.dy = -1
        case let(them, me) where them > me: ret.dy = 1
        default: break
        }
        return ret
    }
    
    func shootingDirectionToNearestPlayer(from node: GameNode) -> CGVector {
        let c1 = node.position
        let player = nearestPlayer(to: node)
        let c2 = player.position
        
        let diff = CGVector(dx: c2.x - c1.x, dy: c2.y - c1.y)
        let vec = diff.simplifiedVector
        return vec
    }
    
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        var t = point
        t.x.subtract(self.x)
        t.y.subtract(self.y)
        return hypot(t.x, t.y)
    }
}



