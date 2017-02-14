//
//  GameUniverse+GameLogic.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/13/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

// MARK: Game Control
extension GameUniverse {
    func startGame() {
        tockTimer?.invalidate()
        tockTimer = Timer.scheduledTimer(withTimeInterval: 0.033, repeats: true) {_ in
            self.tock()
        }
    }
    
    func stopGame() {
        tockTimer?.invalidate()
        
    }
    
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
        guard enemies.count > 0 else {
            return
        }
        
        if enemyIndex >= enemies.count {
            enemyIndex = 0
        }
        let enemy = enemies[enemyIndex]
        enemy.walk()
        enemyIndex = enemyIndex + 1
    }
    
    func gameEndedByShootingPlayer(_ player: Player, bullet: Bullet) {
        stateMachine?.lose()
        blowUp(player)
    }
    
    func gameEndedByTouchingPlayer(_ player: Player, enemy: Enemy) {
        stateMachine?.lose()
        blowUp(player)
    }
    
    func blowUp(_ target: Hittable) {
        if let player = target as? Player {
            stopGame()
            player.alpha = 0
            explode(at: player.position, for: 2.5, completion: {
                player.alpha = 1
            })
        } else if let enemy = target as? Enemy {
            explode(at: enemy.position, for: 0.25, completion: {
            })
        }
    }
    
    func explode(at point: CGPoint, for duration: TimeInterval, completion block: @escaping () -> Swift.Void) {
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.particlePosition = point
            explosion.particleLifetime = CGFloat(duration)
            self.addChild(explosion)
            // Don't forget to remove the emitter node after the explosion
            run(SKAction.wait(forDuration: duration), completion: {
                explosion.removeFromParent()
                block()
            })
        }
    }
}


extension GameUniverse :SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        var hit : Hittable?
        var bullet : Bullet?
        
        if let wall = contact.bodyA.node as? Wall,
            let walker = contact.bodyB.node as? Movable {
            walker.revert(wall)
        } else if let wall = contact.bodyB.node as? Wall,
            let walker = contact.bodyA.node as? Movable  {
            walker.revert(wall)
        } else if let shot = contact.bodyA.node as? Bullet {
            hit = contact.bodyB.node as? Hittable
            bullet = shot
        } else if let shot = contact.bodyB.node as? Bullet {
            bullet = shot
            hit = contact.bodyA.node as? Hittable
        } else if let p1 = contact.bodyA.node as? Player,
            let p2 = contact.bodyB.node as? Enemy {
            gameEndedByTouchingPlayer(p1, enemy: p2)
        } else if let p1 = contact.bodyB.node as? Player,
            let p2 = contact.bodyA.node as? Enemy {
            gameEndedByTouchingPlayer(p1, enemy: p2)
        }
        
        if let target = hit, let bullet = bullet {
            bullet.removeFromParent()
            if let enemy = target as? Enemy {
                blowUp(enemy)
                enemy.dead = true
                if let enemyIdx = enemies.index(of: enemy) {
                    enemies.remove(at: enemyIdx)
                }
                if allDead() {
                    stateMachine?.win()
                }
                enemy.removeFromParent()
            } else if let player = target as? Player {
                guard stateMachine?.currentState != stateMachine?.lost else {
                    return
                }
                gameEndedByShootingPlayer(player, bullet: bullet)
            }
        }
    }
    
    func allDead() -> Bool {
        if enemies.count == 0 {
            return true
        }
        for enemy in enemies {
            if (!enemy.dead) {
                return false
            }
        }
        return true
    }
}


