//
//  GameLevel.swift
//  Robotron2117
//
//  Created by Steve Sparks on 2/17/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class GameLevel {
    var numberOfFootSoldiers : Int = 4
    var numberOfFriendlies : Int = 6
    var speedModifier : CGFloat = 1
    
    init(soldiers: Int, friendlies: Int, options: Dictionary<String,Any> = [:], speed: CGFloat = 1.0) {
        numberOfFriendlies = friendlies
        numberOfFootSoldiers = soldiers
        speedModifier = speed
    }
    
    static var baseLevels : [GameLevel] {
        return [
            GameLevel(soldiers: 3, friendlies: 2),
            GameLevel(soldiers: 4, friendlies: 4),
            GameLevel(soldiers: 5, friendlies: 6),
            GameLevel(soldiers: 6, friendlies: 8),
            GameLevel(soldiers: 8, friendlies: 10),
            GameLevel(soldiers: 10, friendlies: 12),
            GameLevel(soldiers: 12, friendlies: 12),
            GameLevel(soldiers: 14, friendlies: 14),
            GameLevel(soldiers: 16, friendlies: 16),
            GameLevel(soldiers: 18, friendlies: 18),
            GameLevel(soldiers: 20, friendlies: 0),
            GameLevel(soldiers: 20, friendlies: 0, speed: 1.4),
            GameLevel(soldiers: 20, friendlies: 0, speed: 2.0),
            GameLevel(soldiers: 20, friendlies: 20),
            GameLevel(soldiers: 20, friendlies: 20),
            GameLevel(soldiers: 20, friendlies: 20),
            GameLevel(soldiers: 20, friendlies: 20),
            GameLevel(soldiers: 20, friendlies: 20),
        ]
    }
}
