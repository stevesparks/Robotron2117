//
//  GameUniverse.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class GameNode : SKSpriteNode {
    weak var universe : GameUniverse!
}

class GameUniverse: SKScene {
    static let shared = GameUniverse(size: CGSize(width: 1920, height: 1080))
    
    let enemyCount = 20
    let barrierCount = 0
    let friendlyCount = 12
    
    let enemySize = CGSize(width: 20, height: 20)
    let friendlySize = CGSize(width: 20, height: 20)
    let barrierSize = CGSize(width: 5, height: 30)
    static let playerSize = CGSize(width: 40, height: 40)
    
    let screenBorderWidth = CGFloat(10.0)
    
    var playerOne : Player = Player()
    var playerTwo : Player = Player()
    
    var friendlies : [Hittable] = []
    var enemies : [Enemy] = []
    var barriers : [Barrier] = []
    var enemyIndex : Int = 0
    

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

    override func addChild(_ node: SKNode) {
        if let gameNode = node as? GameNode {
            gameNode.universe = self
        }
        super.addChild(node)
    }
    
}

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
        var ret = CGVector(dx: 0, dy: 0)
        
        let diff = CGVector(dx: c2.x - c1.x, dy: c1.y - c2.y)
        
        // These indicate whether we should shoot straight.
        let biasX = (fabs(diff.dx) > fabs(diff.dy*2))
        let biasY = (fabs(diff.dy) > fabs(diff.dx*2))
        if(!biasY) {
            switch (player.position.x, c1.x) {
            case let(them, me) where them < me : ret.dx = -1
            case let(them, me) where them > me: ret.dx = 1
            default: break
            }
        }
        if(!biasX) {
            switch (player.position.y, c1.y) {
            case let(them, me) where them < me: ret.dy = -1
            case let(them, me) where them > me: ret.dy = 1
            default: break
            }
        }
        return ret
    }

}

// MARK: Game Controll
extension GameUniverse {
    func tock() {
        friendlyTurn()
        enemyTurn()
    }
    
    func friendlyTurn() {
        for hittable in self.friendlies {
            hittable.walk()
            if let shooter = hittable as? Shooter {
                _ = shooter.shoot()
            }
        }
    }
    
    func enemyTurn() {
        moveNextEnemy()
        moveNextEnemy()
        moveNextEnemy()
        
        if enemies.count > 0 {
            let shooterIndex = (enemyIndex + (enemies.count/2)) % enemies.count
            if let shooter = enemies[shooterIndex] as? Shooter {
                _ = shooter.shoot()
            }
        }
    }
    
    func moveNextEnemy() {
        let enemy = enemies[enemyIndex]
        enemy.walk()
        enemyIndex = enemyIndex + 1
        if enemyIndex >= enemies.count {
            enemyIndex = 0
        }
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


// MARK: Generation
extension GameUniverse {
    func resetUniverse() {
        clearUniverse()
        
        addBarriers()
        addEnemies()
        addFriendlies()
        addPlayer()
        
        tockTimer?.invalidate()
        tockTimer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true) {_ in
            self.tock()
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
            if let enemy = findEmptySpace({ return FootSoldier() }) as? Enemy {
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
        barriers.removeAll()
    }
}
