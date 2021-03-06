//
//  Civilian.swift
//  Nerdotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Civilian: Hittable {
    enum CivilianType : String {
        case lady = "lady"
        case man = "man"
        case boy = "boy"

        var pointValue : Int {
            switch(self) {
            case .lady: return 300
            case .man: return 200
            case .boy: return 100
            }
        }
        static var allTypes : [CivilianType] = [.lady, .man, .boy]
        static var allTypeNames : [String] = {
            return allTypes.map() { return $0.rawValue }
        }()
    }
    

    convenience init() {
        self.init(texture: SKTexture(imageNamed: "lady-front-1"), color: UIColor.green, size: CGSize(width: 14*3, height: 28*3))
        setupCivilian()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupCivilian()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupCivilian()
    }
    
    convenience init(_ type: CivilianType) {
        self.init(texture: nil, color: UIColor.green, size: CGSize(width: 14*3, height: 28*3))
        self.type = type
        setupCivilian()
    }
    
    func setupCivilian() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.contactTestBitMask = CollisionType.Wall.rawValue | CollisionType.Bullet.rawValue
        self.physicsBody?.categoryBitMask = CollisionType.Civilian.rawValue
        didChangeDirection(.south)
        nextSprite()
        nodeSpeed = 3
    }
    
    var type : CivilianType = {
        switch (arc4random()%3) {
        case 0:  return .lady
        case 1:  return .man
        default: return .boy
        }
    }()
    

    lazy var textureBanks : Dictionary<String, Array<SKTexture>> = {
        return textureDictionary[self.type.rawValue]!
    }()

    override func didChangeDirection(_ direction: Movable.WalkDirection) {
        let set = direction.spriteSet()
        let textureBank : Array<SKTexture> = textureBanks[set]!
        self.spriteTextures = textureBank
        super.didChangeDirection(direction)
    }

    override func revert(_ obstacle: SKSpriteNode) {
        super.revert(obstacle)
        if let wall = obstacle as? Wall {
            direction = wall.safeDirection
        } else {
            direction = direction.reverse()
        }
        stepCount = 50
        walk()
    }


    // MARK: Walking
    var stepCount = 0
    var stepDelay = 0 // arc4random() % 4 // step every Nth frame

    override func walk() {
        if(stepDelay == 0) {
            if(stepCount <= 0) {
                newDirection()
            }
            stepCount = stepCount - 1
            _ = move(direction.vector())
        }
        super.walk()
    }

    func newDirection() {
        stepCount = 10 + Int(arc4random()%20)
        direction = Movable.WalkDirection.random()
    }
}

extension Civilian {
    static let textureDictionary : [String:[String:[SKTexture]]] = {
        var dict : [String:[String:[SKTexture]]] = [:]
        
        for type in CivilianType.allTypeNames {
            var ret : [String : [SKTexture]] = [:]
            for set in ["back", "front"] {
                var arr : [SKTexture] = []
                for frame in [ 1, 2, 3, 2 ] {
                    arr.append(SKTexture(imageNamed: "\(type)-\(set)-\(frame)"))
                }
                ret[set] = arr
            }
            for set in ["right", "left"] {
                var arr : [SKTexture] = []
                
                let list = [1,2,3,4]
                for frame in list {
                    arr.append(SKTexture(imageNamed: "\(type)-\(set)-\(frame)"))
                }
                ret[set] = arr
            }
            dict[type] = ret
        }
        
        return dict
    }()
}
