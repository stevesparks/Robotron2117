//
//  Civilian.swift
//  Robotron2117
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
    }
    
    static var allTypes : [CivilianType] = [.lady, .man, .boy]
    static var allTypeNames : [String] = {
        return allTypes.map() { return $0.rawValue }
    }()

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
        self.walkContext = WanderingNodeContext(self)
        nodeSpeed = 3
    }
    
    var type : CivilianType = {
        switch (arc4random()%3) {
        case 0:  return .lady
        case 1:  return .man
        default: return .boy
        }
    }()
    
    var pointValue : Int {
        switch(type) {
        case .lady: return 300
        case .man: return 200
        case .boy: return 100
        }
    }


    lazy var textureBanks : Dictionary<String, Array<SKTexture>> = {
        return textureDictionary[self.type.rawValue]!
    }()

    override func didChangeDirection(_ direction: Movable.WalkDirection) {
        let set = direction.spriteSet()
        let textureBank : Array<SKTexture> = textureBanks[set]!
        self.spriteTextures = textureBank
    }
}

extension Civilian {
    static let textureDictionary : Dictionary<String, Dictionary<String, Array<SKTexture>>> = {
        var dict : Dictionary<String, Dictionary<String, Array<SKTexture>>> = [:]
        
        for type in allTypeNames {
            var collection : Dictionary<String, Array<SKTexture>> = [:]
            for set in ["back", "front", "right", "left"] {
                var arr : [SKTexture] = []
                for frame in [ 1, 2, 3, 2 ] {
                    arr.append(SKTexture(imageNamed: "\(type)-\(set)-\(frame)"))
                }
                collection[set] = arr
            }
            dict[type] = collection
        }
        
        return dict
    }()
}
