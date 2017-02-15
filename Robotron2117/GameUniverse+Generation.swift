//
//  GameUniverse+Generation.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/13/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Wall : SKSpriteNode {
    
}

// MARK: Generation
extension GameUniverse {
    
    func resetUniverse() {
        clearUniverse()
        addBorder()
        addBarriers()
        addEnemies()
        addFriendlies()
        addPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        stateMachine.begin()
    }
    
    func randomColor() -> SKColor {
        let brightRandomValue = { return (CGFloat(arc4random() & 0xFF) / 512.0) + 0.5 }
        
        let rndRed = brightRandomValue()
        let rndGreen = brightRandomValue()
        let rndBlue = brightRandomValue()
        
        return SKColor(red: rndRed, green: rndGreen, blue: rndBlue, alpha: 1.0)
    }
    
    func randomPointWithinSize(_ size: CGSize) -> CGPoint {
        let x = (CGFloat(Int(arc4random())%Int(size.width)))
        let y = (CGFloat(Int(arc4random())%Int(size.height)))
        return CGPoint(x: x, y: y)
    }
    
    func findEmptySpace(_ t : (Void) -> SKSpriteNode) -> SKSpriteNode? {
        return findEmptySpace(t, avoiding: nil)
    }
    
    func findEmptySpace(_ t : (Void) -> SKSpriteNode, avoiding space: CGRect?) -> SKSpriteNode? {
        let mySize = self.frame.size
        let possible = CGSize(width: mySize.width-(4*screenBorderWidth), height: mySize.height-(4*screenBorderWidth))
        
        var result : SKSpriteNode?
        var triesRemaining = 100
        
        repeat {
            let test = t()
            let newLoc = randomPointWithinSize(possible)
            let offs = screenBorderWidth + screenBorderWidth
            test.position = CGPoint(x: newLoc.x + offs, y: newLoc.y + offs)
            let frame = test.frame
            if let rect = space, test.frame.intersects(rect) {
                // false
            } else {
                var clean = true
                for child in self.children {
                    if child.frame.intersects(frame) {
                        clean = false
                        break
                    }
                }
                if (clean) {
                    result = test
                } else {
                    triesRemaining = triesRemaining - 1
                }
            }
        } while result == nil && triesRemaining > 0
        
        return result
    }
    
    func addBarriers() {
        var barriersRemaining = barrierCount
        while(barriersRemaining>0) {
            if let barrier = findEmptySpace({ return Barrier(texture: nil, color: randomColor(), size: barrierSize) }) as? Barrier {
                addChild(barrier)
                barriers.append(barrier)
                barriersRemaining = barriersRemaining - 1
            }
        }
    }
    
    func addEnemies() {
        var enemiesRemaining = enemyCount
        
        let centerBlock = SKSpriteNode(texture: nil, color: UIColor.clear, size: CGSize(width: 200, height: 200))
        let mySize = self.frame.size
        centerBlock.position = CGPoint(x: mySize.width/2.0, y: mySize.height/2.0)
        
        while(enemiesRemaining>0) {
            if let enemy = findEmptySpace({ return FootSoldier() }, avoiding: centerBlock.frame) as? Enemy {
                addChild(enemy)
                enemies.append(enemy)
                enemiesRemaining = enemiesRemaining - 1
            }
        }
    }
    
    func addFriendlies() {
        var friendliesRemaining = friendlyCount
        while(friendliesRemaining>0) {
            if let friendly = findEmptySpace({ return Civilian() }) as? Civilian {
                addChild(friendly)
                friendlies.append(friendly)
                friendliesRemaining = friendliesRemaining - 1
            }
        }
    }
    
    func addPlayer() {
        let p1 = playerOne
        let mySize = self.frame.size
        p1.position = CGPoint(x: mySize.width/2.0, y: mySize.height/2.0)
        addChild(p1)
        friendlies.append(p1)
        
        playerTwo.position = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
    }
    
    func clearUniverse() {
        for obj in friendlies {
            obj.removeAllActions()
            obj.removeFromParent()
        }
        friendlies.removeAll()
        
        for obj in enemies {
            obj.removeAllActions()
            obj.removeFromParent()
        }
        enemies.removeAll()
        
        for obj in barriers {
            obj.removeAllActions()
            obj.removeFromParent()
        }
        
        for obj in Bullet.bullets {
            obj.removeAllActions()
            obj.removeFromParent()
        }
        Bullet.bullets.removeAll()
        
        barriers.removeAll()
    }
    
    func addBorder() {
        let mySize = self.frame.size
        addWall(CGRect(x:0, y:0, width: screenBorderWidth, height: mySize.height))
        addWall(CGRect(x:mySize.width-screenBorderWidth, y:0, width: screenBorderWidth, height: mySize.height))

        addWall(CGRect(x:0, y:0, width: mySize.width, height: screenBorderWidth))
        addWall(CGRect(x:0, y:mySize.height-screenBorderWidth, width: mySize.width, height: screenBorderWidth))
        
//        let bod = SKPhysicsBody(edgeLoopFrom: borderRect)
//        bod.categoryBitMask = CollisionType.Wall.rawValue
//        bod.contactTestBitMask = CollisionType.Player.rawValue
//        bod.collisionBitMask = CollisionType.Player.rawValue
//        physicsBody = bod
    }
    
    func addWall(_ rect: CGRect) {
                let wallNode = Wall(color: UIColor.red, size: rect.size)
        let bod = SKPhysicsBody(rectangleOf: rect.size)
//        let bod = SKPhysicsBody(edgeLoopFrom: self.frame)
        bod.affectedByGravity = false
        bod.pinned = true
        bod.friction = 100000
        bod.linearDamping = 1000
        bod.angularDamping = 1000
        bod.contactTestBitMask = CollisionType.Player.rawValue
        bod.categoryBitMask = CollisionType.Wall.rawValue
        bod.collisionBitMask = 0x00
        wallNode.physicsBody = bod
        let center = CGPoint(x: rect.origin.x + (rect.size.width/2), y: rect.origin.y + (rect.size.height/2))
        wallNode.position = center
        
        
        addChild(wallNode)
    }
}

