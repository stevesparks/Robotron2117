//
//  Player.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/10/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

enum PlayerNumber {
    case one
    case two
}

class Player: Hittable, Shooter {
    var shotCountdown = 0
    var playerNumber : PlayerNumber = .one
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "dude-front-1"), color: UIColor.black, size: CGSize(width: 15*3, height: 32*3))
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupPlayer()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupPlayer()
    }
    
    func setupPlayer() {
        self.walkContext = PlayerContext(self)
        let bod = SKPhysicsBody(rectangleOf: size)
        bod.collisionBitMask = 0x0
        bod.contactTestBitMask = CollisionType.Enemy.rawValue
        bod.categoryBitMask = CollisionType.Player.rawValue
        self.physicsBody = bod
        nodeSpeed = 10
        self.spriteStep = 1 // always start feet flat
        didChangeDirection(.south)
    }

    var controller : Control? {
        switch(playerNumber) {
        case .one: return ControllerManager.shared.playerOneController
        case .two: return ControllerManager.shared.playerTwoController
        }
        
    }
    
    var step = Int(arc4random()%4)
    
    static let textures : [String : [SKTexture]] = {
        var ret : [String : [SKTexture]] = [:]
        for set in ["back", "front"] {
            var arr : [SKTexture] = []
            for frame in [ 1, 2, 3, 2 ] {
                arr.append(SKTexture(imageNamed: "dude-\(set)-\(frame)"))
            }
            ret[set] = arr
        }
        for set in ["right", "left"] {
            var arr : [SKTexture] = []
            for frame in [ 1, 2, 3, 4 ] {
                arr.append(SKTexture(imageNamed: "dude-\(set)-\(frame)"))
            }
            ret[set] = arr
        }
        return ret
    }()

    override func didChangeDirection(_ direction: Movable.WalkDirection) {
        let set = direction.spriteSet()
        spriteTextures = Player.textures[set]!
        super.didChangeDirection(direction)
    }

    func shoot()  -> Bullet? {
        if(shotCountdown > 0) {
            shotCountdown -= 1
            return nil
        }
        if let ctrl = controller {
            let shoot = ctrl.shootVector
            if shoot != .zero && ctrl.trigger {
                shotCountdown = 5
                let shot = Bullet.aimedAt(shoot, by: self)
                shot.color = UIColor.green
                return shot
            }
        }
        return nil
    }
}

