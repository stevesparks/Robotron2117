//
//  Civilian.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/11/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Civilian: Hittable {
    
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
        switch (arc4random()%3) {
        case 0:
            self.type = .lady
        case 1:
            self.type = .man
        default:
            self.type = .boy
        }
        self.physicsBody?.contactTestBitMask = CollisionType.Wall.rawValue
        self.physicsBody?.categoryBitMask = CollisionType.Player.rawValue
        nextSprite()
    }
    
    convenience init(_ type: CivilianType) {
        self.init(texture: nil, color: UIColor.green, size: CGSize(width: 14*3, height: 28*3))
        self.physicsBody?.contactTestBitMask = CollisionType.Wall.rawValue
        self.physicsBody?.categoryBitMask = CollisionType.Player.rawValue
        self.type = type
        nextSprite()
    }
    
    var type : CivilianType = .lady
    var direction = WalkDirection.random()
    var stepCount = 0
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        nodeSpeed = 3
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        nodeSpeed = 3
    }
  
    var walkDelay = 0
    override func walk() {
        if(walkDelay == 0) {
            if(!move(direction.vector())) {
                direction = direction.reverse()
            }
            
            if(stepCount <= 0) {
                newDirection()
            }
            stepCount = stepCount - 1
            nextSprite()
        }
        walkDelay += 1
        if walkDelay > 3 {
            walkDelay = 0
        }
    }
    
    override func revert(_ obstacle: SKSpriteNode) {
        super.revert(obstacle)
        direction = direction.reverse()
        stepCount = 10 + Int(arc4random()%20)
    }
    
    func newDirection() {
        stepCount = 10 + Int(arc4random()%20)
        direction = WalkDirection.random()
    }
    
    var step = Int(arc4random()%4)
    lazy var textures : Dictionary<String, Array<SKTexture>> = {
        return textureDictionary[self.type.rawValue]!
    }()

    func nextSprite() {
        let set = lastWalkVector.walkDirection.spriteView()
        let textureBank : Array<SKTexture> = textures[set]!
        texture = textureBank[step]
        step = step + 1
        if(step >= textureBank.count) {
            step = 0
        }
    }

}
