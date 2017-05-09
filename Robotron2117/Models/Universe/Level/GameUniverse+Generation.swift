//
//  GameUniverse+Generation.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/13/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit


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
        
        if(level > 0) {
            stateMachine.begin()
        } else {
            _ = stateMachine.enter(GameLevelStateMachine.Playing.self)
        }
    }
    
    func randomColor() -> SKColor {
        let brightRandomValue = { return (CGFloat(arc4random() & 0xFF) / 512.0) + 0.5 }
        
        let rndRed = brightRandomValue()
        let rndGreen = brightRandomValue()
        let rndBlue = brightRandomValue()
        
        return SKColor(red: rndRed, green: rndGreen, blue: rndBlue, alpha: 1.0)
    }
    
    func randomPointWithinPlayfield(forSize size: CGSize = .zero) -> CGPoint {
        let x = (CGFloat(Int(arc4random())%Int(playfieldFrame.size.width - size.width)))
        let y = (CGFloat(Int(arc4random())%Int(playfieldFrame.size.height - size.height)))
        return CGPoint(x: x + size.width/2, y: y + size.height/2)
    }
    
    func findEmptySpace(_ t : (Void) -> SKSpriteNode) -> SKSpriteNode? {
        return findEmptySpace(t, avoiding: nil)
    }
    
    func findEmptySpace(_ t : (Void) -> SKSpriteNode, avoiding space: CGRect?) -> SKSpriteNode? {
        var result : SKSpriteNode?
        var triesRemaining = 100
        
        let test = t()
        repeat {
            let newLoc = randomPointWithinPlayfield(forSize: test.size)
            test.position = newLoc
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
        centerBlock.position = self.frame.center
        
        while(enemiesRemaining>0) {
            if let enemy = findEmptySpace({ return FootSoldier() }, avoiding: centerBlock.frame) as? Enemy {
                enemy.speedModifier = speedModifier
                enemy.name = "FootSoldier-\(enemiesRemaining)"
                enemy.zPosition = CGFloat(enemiesRemaining)*0.25
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
                friendly.zPosition = CGFloat(friendliesRemaining) * -0.25
                friendly.name = "Friendly-\(friendliesRemaining)"
                addChild(friendly)
                friendlies.append(friendly)
                friendliesRemaining = friendliesRemaining - 1
            }
        }
    }
    
    func addPlayer() {
        let p1 = playerOne
        p1.name = "Player One"
        p1.position = self.frame.center
        addChild(p1)
        friendlies.append(p1)
        
//        playerTwo.position = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
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
        addWall(CGRect(x:0, y:0, width: screenBorderWidth, height: mySize.height), name: "West Wall", type: .west)
        addWall(CGRect(x:mySize.width-screenBorderWidth, y:0, width: screenBorderWidth, height: mySize.height), name: "East Wall", type: .east)

        addWall(CGRect(x:0, y:0, width: mySize.width, height: screenBorderWidth), name: "South Wall", type: .south)
        addWall(CGRect(x:0, y:mySize.height-screenBorderWidth, width: mySize.width, height: screenBorderWidth), name: "North Wall", type: .north)
    }
    
    func addWall(_ rect: CGRect, name: String? = nil, type: Wall.WallType) {
        let wallNode = Wall(color: UIColor.red, size: rect.size)
        wallNode.name = name
        wallNode.type = type
        let bod = SKPhysicsBody(rectangleOf: rect.size)
        bod.affectedByGravity = false
        bod.pinned = true
        bod.friction = 100000
        bod.linearDamping = 1000
        bod.angularDamping = 1000
        bod.contactTestBitMask = CollisionType.Player.rawValue | CollisionType.Civilian.rawValue
        bod.categoryBitMask = CollisionType.Wall.rawValue
        bod.collisionBitMask = 0x00
        wallNode.physicsBody = bod
        let center = CGPoint(x: rect.midX, y: rect.midY)
        wallNode.position = center
        addChild(wallNode)
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
