//
//  GameUniverse.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class GameUniverse: SKScene {
    static let shared = GameUniverse(size: CGSize(width: 1920, height: 1080))
    
    let enemyCount = 10
    let barrierCount = 40
    let friendlyCount = 4
    
    let enemySize = CGSize(width: 20, height: 20)
    let friendlySize = CGSize(width: 20, height: 20)
    let barrierSize = CGSize(width: 5, height: 30)
    static let playerSize = CGSize(width: 40, height: 40)

    let screenBorderWidth = CGFloat(10.0)
    
    var playerOne : Player = Player(texture: nil, color: SKColor.white, size: playerSize)
    var playerTwo : Player = Player(texture: nil, color: SKColor.white, size: playerSize)
    
    var friendlies : [Hittable] = []
    var enemies : [Enemy] = []
    var barriers : [Barrier] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        resetUniverse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        resetUniverse()
    }
    
    var tockTimer : Timer?

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        resetUniverse()
        super.pressesBegan(presses, with: event)
    }
}


// MARK: Targeting

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        var t = point
        t.x.subtract(self.x)
        t.y.subtract(self.y)
        return hypot(t.x, t.y)
    }
}

extension Enemy {
    func directionToNearestPlayer() -> CGVector {
        let c1 = self.position
        var player : Player?
        var ret = CGVector(dx: 0, dy: 0)
        var p1Dist = CGFloat.greatestFiniteMagnitude
        let p1 = GameUniverse.shared.playerOne
        var c2 = p1.position
        p1Dist = c2.distance(to: c1)
        
        var p2Dist = CGFloat.greatestFiniteMagnitude
        let p2 = GameUniverse.shared.playerTwo
        c2 = p2.position
        p2Dist = c2.distance(to: c1)
        if(p1Dist < p2Dist) {
            player = GameUniverse.shared.playerOne
        } else {
            player = GameUniverse.shared.playerTwo
        }
    
        if let target = player {
            switch (target.position.x, c1.x) {
            case let(them, me) where them < me: ret.dx = -1
            case let(them, me) where them > me: ret.dx = 1
            default: break
            }
            switch (target.position.y, c1.y) {
            case let(them, me) where them < me: ret.dy = -1
            case let(them, me) where them > me: ret.dy = 1
            default: break
            }
        }
        return ret
    }
}


// MARK: Generation
extension GameUniverse {
    func resetUniverse() {
        clearUniverse()
        
        addBarriers()
        addEnemies()
        addFriendlies()
        addPlayer()
        
        tockTimer?.invalidate()
        tockTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in 
            for enemy in self.enemies {
                enemy.walk()
            }
            for hittable in self.friendlies {
                hittable.walk()
            }
        }
    }

    func randomColor() -> SKColor {
        let brightRandomValue = { return (CGFloat(arc4random() & 0xFF) / 512.0) + 0.5 }
            
        let rndRed = brightRandomValue()
        let rndGreen = brightRandomValue()
        let rndBlue = brightRandomValue()
            
        return SKColor(red: rndRed, green: rndGreen, blue: rndBlue, alpha: 1.0)
    }

    func randomPointWithinSize(_ size: CGSize) -> CGPoint {
        let x = (CGFloat(Int(arc4random())%Int(size.width))+screenBorderWidth)
        let y = (CGFloat(Int(arc4random())%Int(size.height))+screenBorderWidth)
        return CGPoint(x: x, y: y)
    }
    
    func findEmptySpace(_ t : (Void) -> SKSpriteNode) -> SKSpriteNode? {
        let mySize = self.frame.size
        let possible = CGSize(width: mySize.width-(2*screenBorderWidth), height: mySize.height-(2*screenBorderWidth))

        var result : SKSpriteNode?
        var triesRemaining = 100
        
        repeat {
            let test = t()
            let newLoc = randomPointWithinSize(possible)
            test.position = newLoc
            var clean = true
            for child in self.children {
                if child.frame.intersects(test.frame) {
                    clean = false
                    break
                }
            }
            if (clean) {
                result = test
            } else {
                triesRemaining = triesRemaining - 1
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
        while(enemiesRemaining>0) {
            if let enemy = findEmptySpace({ return Enemy(texture: nil, color: SKColor.red, size: enemySize) }) as? Enemy {
                addChild(enemy)
                enemies.append(enemy)
                enemiesRemaining = enemiesRemaining - 1
            }
        }
    }

    func addFriendlies() {
        var friendliesRemaining = friendlyCount
        while(friendliesRemaining>0) {
            if let friendly = findEmptySpace({ return Civilian(texture: nil, color: SKColor.green, size: enemySize) }) as? Civilian {
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
        barriers.removeAll()
    }
}
