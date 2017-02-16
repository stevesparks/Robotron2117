//
//  WalkContext.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/16/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation

typealias GameNodeBlock = () -> Void

class WalkContext {
    var walkBlock : GameNodeBlock = {}
    
    var updateSpriteEveryN = 1
    
    var stepCounter = 0
    
    init(_ block : @escaping GameNodeBlock) {
        walkBlock = block
        stepCounter = updateSpriteEveryN
    }
    
    static var none : WalkContext {
        return WalkContext({})
    }
    
    public func walk() {
        walkBlock()
    }
}


class WanderingNodeContext : WalkContext {
    weak var node : Movable?
    
    init(_ movableNode: Movable) {
        node = movableNode
        super.init({})
        updateSpriteEveryN = 1
    }

    var direction = Movable.WalkDirection.random()
    var stepCount = 0
    var stepDelay = 0 // step every Nth frame
    
    override func walk() {
        guard let node = node else {
            return
        }
        if(stepDelay == 0) {
            if(!node.move(direction.vector())) { // hit a wall
                direction = direction.reverse()
                node.didChangeDirection(direction)
            }
            
            if(stepCount <= 0) {
                newDirection()
            }
            stepCount = stepCount - 1
        }
        stepDelay += 1
        if stepDelay > 3 {
            stepDelay = 0
        }
        super.walk()
    }

    func newDirection() {
        stepCount = 10 + Int(arc4random()%20)
        direction = Movable.WalkDirection.random()
        node?.didChangeDirection(direction)
        node?.nextSprite()
    }
}

class PursuitContext : WalkContext {
    weak var node : Movable?
    
    init(_ movableNode: Movable) {
        node = movableNode
        super.init({})
    }
    
    override func walk() {
        guard let node = node else {
            return
        }
        let vec = node.universe.directionToNearestPlayer(from: node)
        if vec != node.lastWalkVector {
            node.didChangeDirection(vec.walkDirection)
            _ = node.move(vec)
        }
    }
}

class PlayerContext : WalkContext {
    weak var player : Player?

    init(_ plyr : Player) {
        player = plyr
        super.init({})
    }

    override func walk() {
        guard let player = player, let ctrl = player.controller else {
            return
        }
        let vec = ctrl.moveVector
        if vec != .zero {
            _ = player.move(vec)
        }
    }
}

