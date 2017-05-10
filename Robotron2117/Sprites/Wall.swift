//
//  Wall.swift
//  Robotron2117
//
//  Created by Steve Sparks on 5/4/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class Wall : SKSpriteNode {
    enum WallType { case north, south, east, west }
    var type : WallType = .north

    var safeDirection : Movable.WalkDirection {
        switch(type) {
        case .north : return .south
        case .south : return .north
        case .east : return .west
        case .west : return .east
        }
    }
}
